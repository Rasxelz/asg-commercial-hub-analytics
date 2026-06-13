# ASG Commercial Hub: End-to-End Retail Growth & Tenant Risk Pipeline

Proyek ini membangun arsitektur data pipeline end-to-end berbasis cloud untuk mensimulasikan, mengintegrasikan, dan menganalisis operasional pusat komersial Agung Sedayu Group (ASG) di kawasan PIK pada semester pertama tahun 2026. 

## Arsitektur Data (Medallion Architecture)
Proyek ini menerapkan konsep Modern Data Stack untuk memecah silo data dan menghasilkan insight bisnis yang cepat:
1. Data Ingestion & Simulation (Python): Mensimulasikan log transaksi mentah (140.043 baris) dengan menginjeksikan tren retail riil Indonesia tahun 2026 (seperti lonjakan masif Ramadan/Lebaran di bulan Maret dan koreksi pasar pasca-liburan di bulan Mei).
2. Bronze Layer (Raw Data): Data mentah diekspor ke dalam bentuk tabel terstruktur di Google BigQuery Data Warehouse.
3. Silver Layer (Cleaned Data): Mengoptimalkan skema melalui transformasi SQL di BigQuery untuk merapikan tipe data (`CAST`) dan pembersihan string (`TRIM`).
4. Gold Layer (Business Analytics): Menggunakan Advanced SQL (Common Table Expressions & Window Functions seperti `LAG`) untuk menghitung performa makro (Month-on-Month Growth) dan metrik mikro (Tenant Health Risk Matrix).
5. Data Visualization (Power BI): Dashboard interaktif dua halaman yang menyajikan metrik pertumbuhan untuk level Direksi dan manajemen risiko untuk tim Leasing ASG.

## Temuan Bisnis Utama (Key Insights)
* Ramadan & Lebaran Spike (Maret 2026): Sektor F&B dan Fashion mengalami lonjakan pendapatan bulanan hingga 57.79% akibat momentum belanja hari raya di Indonesia.
* Krisis Finansial Sektor Entertainment: Sistem Peringatan Dini yang dibangun mendeteksi bahwa seluruh tenant jangkar di sektor Entertainment berada dalam status CRITICAL RISK karena Rent-to-* Sales Ratio mereka melebihi 100% pada bulan Mei (biaya sewa lebih besar dari omzet).
* Deteksi Tenant Churn: Pipeline database berhasil merekam dan menangani anomali penutupan toko secara proaktif (Tenant ID 104 & 125) dengan status Churned/Closed.

## Tech Stack
* Language: Python, SQL (Google Standard SQL)
* Cloud Data Warehouse: Google BigQuery Sandbox
* Dashboard: Power BI Desktop

## Dashboard Preview
<img width="1128" height="636" alt="image" src="https://github.com/user-attachments/assets/358048d3-8e9d-4069-9ada-9e8ccfabac15" />
