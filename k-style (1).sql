-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Jun 2023 pada 14.34
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `k-style`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `like_reviews`
--

CREATE TABLE `like_reviews` (
  `id_member` bigint(20) DEFAULT NULL,
  `id_review` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `like_reviews`
--

INSERT INTO `like_reviews` (`id_member`, `id_review`) VALUES
(1, 1),
(2, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `members`
--

CREATE TABLE `members` (
  `id_member` bigint(20) NOT NULL,
  `username` varchar(191) DEFAULT NULL,
  `gender` longtext DEFAULT NULL,
  `skin_type` longtext DEFAULT NULL,
  `skin_color` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `members`
--

INSERT INTO `members` (`id_member`, `username`, `gender`, `skin_type`, `skin_color`) VALUES
(1, 'John', 'Male', '', ''),
(2, 'Aldi', 'Male', '', ''),
(3, 'Aldo', 'Male', '', ''),
(4, 'Aldous', 'Male', 'Oily', 'Fair');

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `id_product` bigint(20) NOT NULL,
  `name_product` longtext DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`id_product`, `name_product`, `price`) VALUES
(1, 'Product Name', 9.99);

-- --------------------------------------------------------

--
-- Struktur dari tabel `review_products`
--

CREATE TABLE `review_products` (
  `id_review` bigint(20) NOT NULL,
  `id_product` bigint(20) DEFAULT NULL,
  `id_member` bigint(20) DEFAULT NULL,
  `desc_review` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `review_products`
--

INSERT INTO `review_products` (`id_review`, `id_product`, `id_member`, `desc_review`) VALUES
(1, 1, 4, 'mantap bang');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `like_reviews`
--
ALTER TABLE `like_reviews`
  ADD KEY `fk_like_reviews_member` (`id_member`),
  ADD KEY `fk_review_products_likes` (`id_review`);

--
-- Indeks untuk tabel `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id_member`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id_product`);

--
-- Indeks untuk tabel `review_products`
--
ALTER TABLE `review_products`
  ADD PRIMARY KEY (`id_review`),
  ADD KEY `fk_members_review` (`id_member`),
  ADD KEY `fk_products_review` (`id_product`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `members`
--
ALTER TABLE `members`
  MODIFY `id_member` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `products`
--
ALTER TABLE `products`
  MODIFY `id_product` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `review_products`
--
ALTER TABLE `review_products`
  MODIFY `id_review` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `like_reviews`
--
ALTER TABLE `like_reviews`
  ADD CONSTRAINT `fk_like_reviews_member` FOREIGN KEY (`id_member`) REFERENCES `members` (`id_member`),
  ADD CONSTRAINT `fk_review_products_likes` FOREIGN KEY (`id_review`) REFERENCES `review_products` (`id_review`);

--
-- Ketidakleluasaan untuk tabel `review_products`
--
ALTER TABLE `review_products`
  ADD CONSTRAINT `fk_members_review` FOREIGN KEY (`id_member`) REFERENCES `members` (`id_member`),
  ADD CONSTRAINT `fk_products_review` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_product`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
