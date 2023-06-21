package main

import (
	"fmt"
	"log"
	"net/http"

	echo "github.com/labstack/echo/v4"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type Product struct {
	IDProduct   int             `gorm:"primaryKey" json:"id_product"`
	NameProduct string          `json:"name_product"`
	Price       float32         `json:"price"`
	Review      []ReviewProduct `gorm:"foreignKey:IDProduct;references:IDProduct"`
}

type Member struct {
	IDMember  int           `gorm:"primaryKey" json:"id_member"`
	Username  string        `gorm:"unique" json:"username"`
	Gender    string        `json:"gender"`
	SkinType  string        `json:"skin_type"`
	SkinColor string        `json:"skin_color"`
	Review    ReviewProduct `gorm:"foreignKey:IDMember"`
}

type ReviewProduct struct {
	IDReview   int          `gorm:"primaryKey" json:"id_review"`
	IDProduct  int          `json:"id_product"`
	IDMember   int          `json:"id_member"`
	DescReview string       `json:"desc_review"`
	Likes      []LikeReview `gorm:"foreignKey:IDReview" json:"likes"`
}

type LikeReview struct {
	IDMember int    `json:"id_member"`
	IDReview int    `json:"id_review"`
	Member   Member `gorm:"foreignKey:IDMember"`
}

type ReviewData struct {
	Username   string `json:"username"`
	Gender     string `json:"gender"`
	SkinType   string `json:"skin_type"`
	SkinColor  string `json:"skin_color"`
	DescReview string `json:"desc_review"`
	TotalLike  int64  `json:"jumlah_like_review"`
}

var Db *gorm.DB

func main() {
	// Inisialisasi DB
	db, err := gorm.Open(mysql.Open("root:@/k-style?parseTime=true"), &gorm.Config{})
	if err != nil {
		log.Fatalln("Failed to Connect to DB : ", err)
	}

	Db = db
	// Migrate
	db.AutoMigrate(&Product{}, &ReviewProduct{}, &LikeReview{}, &Member{})

	e := echo.New()
	api := e.Group("/api")

	api.POST("/member", InsertMember)
	api.PUT("/member/:id", UpdateMember)
	api.DELETE("/member/:id", DeleteMember)
	api.GET("/members", AllMembers)
	api.POST("/products", InsertProduct)
	api.GET("/products/:id", SelectProduct)
	api.POST("/like_review", InsertLike)
	api.DELETE("/like_review/:id", DeleteLike)

	e.Start(":3000")
}

// Insert Data to Member
func InsertMember(c echo.Context) error {
	var member Member
	u := new(Member)
	if err := c.Bind(u); err != nil {
		return c.String(http.StatusBadRequest, "Bad Request")
	}
	if result := Db.Where(&Member{Username: u.Username}).First(&member); result.Error == nil {
		return c.JSON(http.StatusBadRequest, "Username is exist")
	}

	postToDB := Db.Create(u)

	if postToDB.Error != nil {
		return c.JSON(http.StatusInternalServerError, postToDB.Error)
	}

	return c.JSON(http.StatusCreated, u)
}

// Update data member
func UpdateMember(c echo.Context) error {
	id := c.Param("id")
	u := new(Member)

	if err := c.Bind(u); err != nil {
		return c.String(http.StatusBadRequest, "Bad Request")
	}

	if result := Db.Model(&Member{}).Where("id_member = ?", id).Updates(u); result.Error != nil {
		return c.JSON(http.StatusInternalServerError, result.Error)
	}

	return c.JSON(http.StatusOK, "Update Member Successfully")
}

// Delete Member by Id
func DeleteMember(c echo.Context) error {
	id := c.Param("id")

	if result := Db.Delete(&Member{}, id); result.Error != nil {
		return c.JSON(http.StatusInternalServerError, result.Error)
	}

	return c.JSON(http.StatusAccepted, "Delete Member Successfully")

}

// Select All Members
func AllMembers(c echo.Context) error {
	members := []Member{}
	if result := Db.Find(&members); result.Error != nil {
		return c.JSON(http.StatusInternalServerError, result.Error)
	}

	return c.JSON(http.StatusOK, members)
}

// Select Product and join
func SelectProduct(c echo.Context) error {
	id := c.Param("id")

	var result []ReviewData
	query := Db.Raw("SELECT members.username, members.gender, members.skin_type, members.skin_color, review_products.desc_review, COUNT(like_reviews.id_review) AS jumlah_like_review FROM products JOIN review_products ON review_products.id_product = products.id_product JOIN members ON review_products.id_member = members.id_member JOIN like_reviews ON like_reviews.id_review = review_products.id_review WHERE products.id_product = ? GROUP BY members.username, members.gender, members.skin_type, members.skin_color, review_products.desc_review", id).Scan(&result)
	for _, x := range result {
		fmt.Println("Count :", x.TotalLike)
	}
	if query.Error != nil {
		return c.String(http.StatusInternalServerError, query.Error.Error())
	}

	return c.JSON(http.StatusOK, result)
}

func InsertProduct(c echo.Context) error {
	p := new(Product)

	if err := c.Bind(p); err != nil {
		return c.String(http.StatusBadRequest, err.Error())
	}

	result := Db.Create(p)

	if result.Error != nil {
		return c.JSON(http.StatusInternalServerError, result.Error)
	}

	return c.JSON(http.StatusCreated, "Create Product Successfully")
}

// insert like_review
func InsertLike(c echo.Context) error {
	like := new(LikeReview)
	if err := c.Bind(like); err != nil {
		return c.String(http.StatusBadRequest, err.Error())
	}

	if result := Db.Create(&like); result.Error != nil {
		return c.JSON(http.StatusInternalServerError, result.Error)
	}

	return c.JSON(http.StatusCreated, "Insert Like Successfully")
}

// delete like_review
func DeleteLike(c echo.Context) error {
	id := c.Param("id")
	result := Db.Delete(&LikeReview{}, id)

	if result.Error != nil {
		return c.JSON(http.StatusInternalServerError, result.Error)
	}

	return c.JSON(http.StatusOK, "Delete Like Successfully")
}
