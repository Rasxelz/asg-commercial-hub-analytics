CREATE OR REPLACE VIEW asg_commercial_hub.gold_tenant_health_matrix AS
WITH may_2026_sales AS (
  SELECT
    tenant_id,
    SUM(amount) AS total_sales_may
  FROM asg_commercial_hub.silver_fact_sales_transactions
  WHERE EXTRACT(MONTH FROM transaction_date) = 5
  GROUP BY tenant_id
),
billing_stress AS (
  SELECT
    tenant_id,
    COUNTIF(payment_status IN ('Unpaid', 'Late')) AS delinquency_count
  FROM asg_commercial_hub.silver_fact_monthly_bills
  GROUP BY tenant_id
)
SELECT
  t.tenant_id,
  t.tenant_name,
  t.category,
  t.monthly_rental_fee,
  COALESCE(s.total_sales_may, 0) AS total_sales_may,
  
  CASE 
    WHEN COALESCE(s.total_sales_may, 0) = 0 THEN 100.0
    ELSE ROUND((t.monthly_rental_fee / s.total_sales_may) * 100, 2)
  END AS rent_to_sales_ratio_pct,
  
  COALESCE(b.delinquency_count, 0) AS financial_delinquency_count,
  
  CASE
    WHEN COALESCE(s.total_sales_may, 0) = 0 THEN 'CHURNED / CLOSED'
    WHEN (t.monthly_rental_fee / s.total_sales_may) * 100 > 30.0 OR b.delinquency_count >= 2 THEN 'CRITICAL RISK'
    WHEN (t.monthly_rental_fee / s.total_sales_may) * 100 BETWEEN 15.0 AND 30.0 OR b.delinquency_count = 1 THEN 'WARNING'
    ELSE 'HEALTHY'
  END AS tenant_health_status

FROM asg_commercial_hub.silver_dim_tenants t
LEFT JOIN may_2026_sales s ON t.tenant_id = s.tenant_id
LEFT JOIN billing_stress b ON t.tenant_id = b.tenant_id
ORDER BY rent_to_sales_ratio_pct DESC;