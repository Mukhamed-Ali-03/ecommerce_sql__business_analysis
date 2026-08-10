# E-Commerce SQL Business Analysis (MySQL)

---

## Project Overview

This project analyzes an international e-commerce dataset using **MySQL** and **MySQL Workbench**.

The main goal was to transform raw, flat sales data into a structured relational database and use SQL queries to analyze revenue, profitability, customer segments, product performance, market contributions, discount impacts, and shipping efficiency.

The original dataset was provided as a single flat CSV file containing 51,290 sales records. 

The raw data was first loaded into a staging table (`rawsales`) and validated. After that, it was transformed and normalized into four relational tables:
- `customers`
- `orders`
- `products`
- `orderdetails`

Primary and foreign keys were used to establish relationships between the tables to support multi-table business analysis.

---

## Project Structure

- `data/` - Raw dataset files
- `database/` - Database creation, data import, transformation, and validation scripts
- `queries/` - SQL business analysis queries
- `screenshots/` - Visual results of query execution
- `documentation/` - EER diagram schema, project design documents, and detailed business insights

---

## Business Objectives

The analysis focuses on identifying:
- Sales and revenue trends over time
- High-value customer profitability
- Customer segment performance
- Product category and sub-category profitability
- High-revenue but loss-making products
- Country revenue and profit contributions
- The financial impact of different discount levels
- Shipping cost efficiency across modes
- Most profitable products within each category
- Common characteristics of the largest loss-making transactions

---

## SQL Skills (MySQL)

- SELECT statements, filtering (`WHERE`), and sorting (`ORDER BY`)
- Aggregate functions (`SUM`, `COUNT`, `AVG`)
- Data grouping and filtering (`GROUP BY`, `HAVING`)
- Multiple-table `INNER JOIN` operations
- Subqueries and Derived Tables
- Conditional logic with `CASE` expressions
- MySQL Date functions (`DATE_FORMAT`, `STR_TO_DATE`, `YEAR`, `MONTH`)
- Row limitation using `LIMIT` (instead of `TOP`)
- Unique values identification using `DISTINCT`
- Window and Ranking functions (`RANK() OVER`)
- Data type conversion using `CAST` and `DECIMAL` (instead of `CONVERT`)
- Relational database design and EER modeling

---

## Database Structure

The raw dataset was first imported into a staging table and then successfully normalized into a relational database consisting of four main tables:
1. **customers** — Stores unique customer profiles and registration details.
2. **orders** — Tracks high-level transaction data, order dates, and status.
3. **products** — Manages the product catalog, unit prices, and unit costs.
4. **orderdetails** — Stores granular line-item data, quantities, and applied discounts for multi-product orders.

--- 

## Business Analysis & Key Questions

1. **Monthly Sales Performance:** How are total revenue, number of orders, and average order value changing over time?
2. **Top Customers & Profitability:** Who are the top 10 customers by revenue, and how profitable are they?
3. **Customer Segment Performance:** Which customer segments generate the most revenue and profit?
4. **Category & Sub-Category Profitability:** Which product categories and sub-categories are the most and least profitable?
5. **High-Sales, Low-Profit Products:** Which products generate high sales but poor or negative profitability?
6. **Country Revenue & Profit Contribution:** Which countries contribute the most to company revenue and profit, and are their profit contributions proportional?
7. **Discount Impact Analysis:** How do different discount levels affect sales volume, revenue, and profitability?
8. **Shipping Mode Efficiency:** Which shipping modes are the most financially efficient?
9. **Product Profit Ranking:** What are the top 3 most profitable products within each product category?
10. **Largest Loss-Making Transactions:** Which individual sales transactions generated the largest losses, and what characteristics do they have in common?

--- 

## Key Business Insights

- **Growth was volume-driven:** Total revenue increased over the years primarily because of a growing number of orders, rather than substantially higher Average Order Value (AOV).
- **Revenue did not guarantee profitability:** Several high-revenue customers (like Sean Miller and Becky Martin) and top-selling products actually generated weak or negative profit margins.
- **Product-level profitability problems were identified:** The **Tables** sub-category within the Furniture category was identified as highly unprofitable, creating a major financial loss for the business.
- **Aggressive discounting significantly damaged profitability:** High-discount transactions (50% to 70% off) were strongly associated with massive losses, proving that extreme discounting hurts the company's bottom line.
- **Market contribution differed substantially:** Highly efficient markets like **China** and **India** contributed disproportionately more to total profit than to total revenue.
- **Shipping efficiency varied considerably:** **Standard Class** was proven to be the most financially efficient shipping method, keeping shipping costs relative to revenue much lower than faster options like Same Day or First Class.
