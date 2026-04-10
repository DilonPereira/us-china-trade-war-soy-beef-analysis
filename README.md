# U.S.-China Trade War Soy & Beef Analysis

A data-driven analysis of the causal link between the 2018 U.S.-China Trade War and the accelerated deforestation in the Brazilian Amazon, driven by shifted global demand for Soy and Beef.

**Data cleaning, transformation, and exploratory analysis pipeline** supporting the Master's thesis:

> **"Trade Shock and Environmental Spillover: The Causal Link Between U.S.-China Trade War and Increased Soy-Beef Driven Deforestation in the Brazilian Amazon"**

**Author**: Dilon Pereira  
**University**: University of Passau – Chair of International Economics  
**Date**: March 2026

### Project Purpose
This repository contains the complete SQL workflow used to prepare and analyze the core dataset (`backup_df`) for the empirical sections of the thesis (Chapters 4, 6 & 7). It transforms raw export and deforestation data into clean, analysis-ready structures and generates the two key views used in the econometric analysis:

- `vw_Annual_Growth` → yearly soy export totals to China + deforestation + YoY growth
- `vw_TradeWar_Comparison` → pre- vs post-2018 trade war aggregates (soy + deforestation)

### Key Features
- Robust data cleaning (handling commas, nulls, date conversion)
- Safe column creation and updates
- Annual growth calculations with lagged values
- Pre-/Post-Trade War comparison (2018 breakpoint)
- Fully reproducible – just run the main script

### Thesis Context
The analysis isolates the causal effect of the 2018 U.S.–China trade war on Amazon deforestation through:
- Massive trade diversion of soybeans and beef toward Brazil
- Instrumental variable (U.S.–China Tension Index)
- Difference-in-Differences design
- Panel data on exports to China vs. EU (control)

This SQL pipeline prepares the exact export and deforestation variables used in the OLS, IV, and DiD regressions presented in the thesis.

---

**Tech Stack**: SQL Server | T-SQL | Views | Data Cleaning
