# SHUB Test Result - Nguyen Khai

Welcome to my project for the SHUB COMPANY JSC test! This repository contains all the tasks I completed, showcasing my skills and knowledge.

## Table of Contents
- [Task 01 - Data Report](#task-01---data-report)
- [Task 02 - Form](#task-02---form)
- [Task 03 - Database](#task-03---database)
- [Task 04 - Data Structure & Algorithm](#task-04---data-structure--algorithm)
- [Technologies Used](#technologies-used)
- [Installation Instructions](#installation-instructions)

---

## Task 01 - Data Report

### Overview
- Implemented a Restful API using **Node.js**.
- Managed state using **Flutter Bloc**.

**Video Task Completed**: [Watch Here](https://www.youtube.com/watch?v=dUBCEXIw_74)

---

## Task 02 - Form

### Overview
- Built a dynamic form with validation using:
  - [Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)
  - [Form Builder Validators](https://pub.dev/packages/form_builder_validators)

**Video Task Completed**: [Watch Here](https://www.youtube.com/watch?v=QorpA6qZuvs)

---

## Task 03 - Database

### Overview
- Designed and implemented a database using **Microsoft SQL Server**.

![Database Schema](https://github.com/user-attachments/assets/27a5c1a5-c6a2-4ffb-9de5-7d821da617a9)

---

## Task 04 - Data Structure & Algorithm

### How It Works:
1. **Preprocessing**:
   - Calculated three prefix sum arrays:
     - **`prefix_sum`**: Total sum of elements.
     - **`even_sum`**: Sum of elements at even indices.
     - **`odd_sum`**: Sum of elements at odd indices.

2. **Query Types**:
   - **Type 1**: Get the sum of elements from index `l` to `r`:
     ```
     total_sum = prefix_sum[r + 1] - prefix_sum[l]
     ```

   - **Type 2**: Get the difference between even-indexed and odd-indexed sums:
     ```
     result = (even_sum[r + 1] - even_sum[l]) - (odd_sum[r + 1] - odd_sum[l])
     ```

---

## Technologies Used

Here's a list of the technologies I've used to run the project:
- **Flutter**
- **Python 3.12**
- **Node.js**
- **Microsoft SQL Server**

---

## Installation Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/NgKhai/SHUB_test_result.git
