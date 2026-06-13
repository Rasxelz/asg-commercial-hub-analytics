CREATE OR REPLACE VIEW asg_commercial_hub.gold_mom_category_growth AS
WITH monthly_sales AS (
  SELECT
    t.category,
    EXTRACT(MONTH FROM s.transaction_date) AS month_num,
    FORMAT_DATE('%B %Y', s.transaction_date) AS month_name,
    SUM(s.amount) AS total_revenue
  FROM asg_commercial_hub.silver_fact_sales_transactions s
  JOIN asg_commercial_hub.silver_dim_tenants t ON s.tenant_id = t.tenant_id
  GROUP BY t.category, month_num, month_name
),
mom_calculation AS (
  SELECT
    category,
    month_num,
    month_name,
    total_revenue,
    LAG(total_revenue) OVER(PARTITION BY category ORDER BY month_num) AS previous_month_revenue
  FROM monthly_sales
)
SELECT
  category,
  month_name,
  total_revenue,
  previous_month_revenue,
  ROUND(total_revenue - previous_month_revenue, 2) AS net_growth,
  ROUND(((total_revenue - previous_month_revenue) / previous_month_revenue) * 100, 2) AS mom_growth_percentage
FROM mom_calculation
ORDER BY category, month_num;