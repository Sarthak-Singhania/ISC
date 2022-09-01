-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 31, 2022 at 06:32 PM
-- Server version: 10.5.12-MariaDB-cll-lve
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u724843278_ISC`
--

-- --------------------------------------------------------

--
-- Table structure for table `Badminton`
--

CREATE TABLE `Badminton` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Badminton`
--

INSERT INTO `Badminton` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '6:30am-7:30am', 14, 14, 13, 0, 16, 16, 15),
(2, '7:30am-8:30am', 16, 16, 16, 0, 16, 16, 16),
(4, '4:00pm-5:00pm', 16, 16, 16, 16, 16, 16, 16),
(5, '5:00pm-6:00pm', 16, 16, 16, 14, 14, 15, 16),
(6, '6:00pm-7:00pm', 16, 16, 16, 16, 16, 16, 16),
(7, '7:00pm-8:00pm', 16, 16, 16, 16, 16, 16, 16),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Basketball`
--

CREATE TABLE `Basketball` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Basketball`
--

INSERT INTO `Basketball` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '6:30am-7:30am', 50, 50, 50, 0, 50, 50, 50),
(2, '7:30am-8:30am', 50, 50, 50, 0, 50, 50, 50),
(4, '4:00pm-5:00pm', 50, 50, 50, 50, 50, 50, 50),
(5, '5:00pm-6:00pm', 50, 50, 50, 50, 50, 50, 50),
(6, '6:00pm-7:00pm', 50, 50, 50, 50, 50, 50, 50),
(7, '7:00pm-8:00pm', 50, 50, 50, 50, 50, 50, 50),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `blacklist`
--

CREATE TABLE `blacklist` (
  `ID` int(11) NOT NULL,
  `Student_Name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SNU_ID` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date` datetime NOT NULL DEFAULT current_timestamp(),
  `Booking_ID` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `ID` int(11) NOT NULL,
  `Student_Name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `SNU_ID` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Booking_ID` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Game` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date` date NOT NULL,
  `Slot` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `Confirm` tinyint(1) NOT NULL,
  `Present` tinyint(1) NOT NULL,
  `Cancelled` tinyint(1) NOT NULL,
  `Cancellation_Date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`ID`, `Student_Name`, `SNU_ID`, `Booking_ID`, `Game`, `Date`, `Slot`, `Confirm`, `Present`, `Cancelled`, `Cancellation_Date`) VALUES
(1, 'Sarthak Singhania', 'ss878@snu.edu.in', 'H97ZQNCNU', 'Volleyball', '2022-03-12', '4:00pm-5:00pm', 1, 0, 0, NULL),
(2, 'Sarthak Singhania', 'ss878@snu.edu.in', '0YVGRCQN3', 'Badminton', '2022-03-10', '5:00pm-6:00pm', 1, 0, 0, NULL),
(3, 'Sarthak Singhania', 'ss878@snu.edu.in', '25I3DZF98', 'Badminton', '2022-03-11', '5:00pm-6:00pm', 1, 0, 0, NULL),
(4, 'Tushar Mishra', 'tm217@snu.edu.in', '25I3DZF98', 'Badminton', '2022-03-11', '5:00pm-6:00pm', 1, 0, 0, NULL),
(5, 'Tushar Mishra', 'tm217@snu.edu.in', 'CHR6Y5GW3', 'Badminton', '2022-03-24', '5:00pm-6:00pm', 1, 0, 0, NULL),
(6, 'Tushar Mishra', 'tm217@snu.edu.in', '10IIDPGY9', 'Badminton', '2022-03-26', '5:00pm-6:00pm', 1, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `faq`
--

CREATE TABLE `faq` (
  `ID` int(11) NOT NULL,
  `Question` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `Answer` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `faq`
--

INSERT INTO `faq` (`ID`, `Question`, `Answer`) VALUES
(1, 'Why have I been blacklisted?', 'When a student is marked absent by the instructor or does not turn up for the scheduled class, the student is blacklisted for 1 week.');

-- --------------------------------------------------------

--
-- Table structure for table `Football`
--

CREATE TABLE `Football` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Football`
--

INSERT INTO `Football` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(2, '7:15am-8:30am', 50, 50, 50, 0, 50, 50, 0),
(6, '6:00pm-8:00pm', 50, 50, 50, 50, 50, 50, 0),
(9, '5:00pm-6:00pm', 50, 50, 50, 50, 50, 50, 0),
(10, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `ID` int(11) NOT NULL,
  `Sports_Name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `URL` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `Capacity` int(11) NOT NULL,
  `Max_Person` int(11) NOT NULL,
  `Max_Days` int(11) NOT NULL,
  `Enabled` tinyint(1) NOT NULL,
  `Info` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`ID`, `Sports_Name`, `URL`, `Capacity`, `Max_Person`, `Max_Days`, `Enabled`, `Info`) VALUES
(1, 'Badminton', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Badminton.png?alt=media&token=f994f06e-238c-4f9e-a28e-dfe0fd05e872', 16, 4, 3, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(2, 'Gym', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Gym.png?alt=media&token=5be0aa80-a2d3-4b0a-af70-1ceab382cfa0', 10, 1, 3, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(3, 'Table Tennis', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Table%20Tennis.png?alt=media&token=3edc8f63-d7e1-49af-aa87-197b9f77f7e4', 20, 2, 5, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(4, 'Yoga', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Yoga.png?alt=media&token=1d23b842-302e-451b-b2b2-f41143d85ccd', 20, 1, 6, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(5, 'Football', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Football.png?alt=media&token=dc7297e1-0c33-4f87-959c-1048aa1e257e', 50, 11, 7, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(6, 'Squash', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Squash.png?alt=media&token=fdca0cae-3897-47a5-a819-e6c3ee1ce7d3', 20, 2, 3, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(7, 'Tennis', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Tennis.png?alt=media&token=f6532d82-4eae-403a-bb6c-4c3001837930', 10, 4, 7, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(8, 'Volleyball', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Volleyball.png?alt=media&token=d85bfc7b-2034-4541-a9bb-0334827f2b70', 50, 6, 7, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present'),
(10, 'Basketball', 'https://firebasestorage.googleapis.com/v0/b/snuisc.appspot.com/o/Basketball.png?alt=media&token=74a143ee-522c-49df-8b7c-b15c67ccb23c', 50, 1, 7, 1, 'Only 4 people per court.\\nStudent shall be blacklisted if they are not present');

-- --------------------------------------------------------

--
-- Table structure for table `Gym`
--

CREATE TABLE `Gym` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Gym`
--

INSERT INTO `Gym` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '6:00am-7:00am', 10, 10, 10, 0, 10, 10, 0),
(2, '7:00am-8:00am', 10, 10, 10, 0, 10, 10, 0),
(3, '8:00am-9:00am', 10, 10, 10, 0, 10, 10, 0),
(4, '4:00pm-5:00pm', 10, 10, 10, 10, 10, 10, 0),
(5, '5:00pm-6:00pm', 10, 10, 10, 10, 10, 10, 0),
(6, '6:00pm-7:00pm', 10, 10, 10, 10, 10, 10, 0),
(7, '7:00pm-8:00pm', 10, 10, 10, 10, 10, 10, 0),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Squash`
--

CREATE TABLE `Squash` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Squash`
--

INSERT INTO `Squash` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '6:30am-7:30am', 20, 20, 20, 0, 20, 20, 0),
(2, '7:30am-8:30am', 20, 20, 20, 0, 20, 20, 0),
(4, '4:00pm-5:00pm', 20, 20, 20, 20, 20, 20, 0),
(5, '5:00pm-6:00pm', 20, 20, 20, 20, 20, 20, 0),
(6, '6:00pm-7:00pm', 20, 20, 20, 20, 20, 20, 0),
(7, '7:00pm-8:00pm', 20, 20, 20, 20, 20, 20, 0),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Table_Tennis`
--

CREATE TABLE `Table_Tennis` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Table_Tennis`
--

INSERT INTO `Table_Tennis` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '6:30am-7:30am', 20, 20, 20, 0, 20, 20, 0),
(2, '7:30am-8:30am', 20, 20, 20, 0, 20, 20, 0),
(4, '4:00pm-5:00pm', 20, 20, 20, 20, 20, 20, 0),
(5, '5:00pm-6:00pm', 20, 20, 20, 20, 20, 20, 0),
(6, '6:00pm-7:00pm', 20, 20, 20, 20, 20, 20, 0),
(7, '7:00pm-8:00pm', 20, 20, 20, 20, 20, 20, 0),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `team_training`
--

CREATE TABLE `team_training` (
  `ID` int(11) NOT NULL,
  `Game` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Slot` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Day` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `team_training`
--

INSERT INTO `team_training` (`ID`, `Game`, `Slot`, `Day`) VALUES
(1, 'Badminton', '7:00pm-8:00pm', 'Monday'),
(2, 'Badminton', '7:00pm-8:00pm', 'Tuesday'),
(3, 'Badminton', '7:00pm-8:00pm', 'Wednesday'),
(4, 'Badminton', '7:00pm-8:00pm', 'Thursday'),
(5, 'Badminton', '7:00pm-8:00pm', 'Friday'),
(6, 'Badminton', '7:00pm-8:00pm', 'Saturday'),
(7, 'Badminton', '7:00pm-8:00pm', 'Sunday');

-- --------------------------------------------------------

--
-- Table structure for table `Tennis`
--

CREATE TABLE `Tennis` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Tennis`
--

INSERT INTO `Tennis` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '7:00am-8:30am', 10, 10, 10, 0, 10, 10, 0),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Volleyball`
--

CREATE TABLE `Volleyball` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Volleyball`
--

INSERT INTO `Volleyball` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(4, '4:00pm-5:00pm', 50, 50, 50, 50, 50, 49, 0),
(5, '5:00pm-6:00pm', 50, 50, 50, 50, 50, 50, 0),
(6, '6:00pm-7:00pm', 50, 50, 50, 50, 50, 50, 0),
(7, '7:00pm-8:00pm', 50, 50, 50, 50, 50, 50, 0),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Yoga`
--

CREATE TABLE `Yoga` (
  `ID` int(11) NOT NULL,
  `Slots` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Monday` int(11) UNSIGNED DEFAULT NULL,
  `Tuesday` int(11) UNSIGNED DEFAULT NULL,
  `Wednesday` int(11) UNSIGNED DEFAULT NULL,
  `Thursday` int(11) UNSIGNED DEFAULT NULL,
  `Friday` int(11) UNSIGNED DEFAULT NULL,
  `Saturday` int(11) UNSIGNED DEFAULT NULL,
  `Sunday` int(11) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `Yoga`
--

INSERT INTO `Yoga` (`ID`, `Slots`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`) VALUES
(1, '6:30am-7:30am', 20, 20, 20, 0, 20, 20, 0),
(2, '7:30am-8:30am', 20, 20, 20, 0, 20, 20, 0),
(4, '4:00pm-5:00pm', 20, 20, 20, 20, 20, 20, 0),
(5, '5:00pm-6:00pm', 20, 20, 20, 20, 20, 20, 0),
(6, '6:00pm-7:00pm', 20, 20, 20, 20, 20, 20, 0),
(7, '7:00pm-8:00pm', 20, 20, 20, 20, 20, 20, 0),
(8, 'Enabled', 1, 1, 1, 1, 1, 1, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Badminton`
--
ALTER TABLE `Badminton`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Basketball`
--
ALTER TABLE `Basketball`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `SNU_ID` (`SNU_ID`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `faq`
--
ALTER TABLE `faq`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Football`
--
ALTER TABLE `Football`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Gym`
--
ALTER TABLE `Gym`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Squash`
--
ALTER TABLE `Squash`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Table_Tennis`
--
ALTER TABLE `Table_Tennis`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `team_training`
--
ALTER TABLE `team_training`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Tennis`
--
ALTER TABLE `Tennis`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Volleyball`
--
ALTER TABLE `Volleyball`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `Yoga`
--
ALTER TABLE `Yoga`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Badminton`
--
ALTER TABLE `Badminton`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Basketball`
--
ALTER TABLE `Basketball`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `faq`
--
ALTER TABLE `faq`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Football`
--
ALTER TABLE `Football`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Gym`
--
ALTER TABLE `Gym`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Squash`
--
ALTER TABLE `Squash`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Table_Tennis`
--
ALTER TABLE `Table_Tennis`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `team_training`
--
ALTER TABLE `team_training`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Tennis`
--
ALTER TABLE `Tennis`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Volleyball`
--
ALTER TABLE `Volleyball`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Yoga`
--
ALTER TABLE `Yoga`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
