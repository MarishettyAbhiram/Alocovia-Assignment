--Revenue Metrics
-- i. Target vs Achievement for the month
SELECT DATE_TRUNC('month', payment_date) AS month,
       SUM(amount) AS achieved_revenue,
       SUM(target_amount) AS target_revenue,
       SUM(amount) * 100.0 / SUM(target_amount) AS achievement_percent
FROM revenue
GROUP BY DATE_TRUNC('month', payment_date);

-- ii. Split between 3-month trials vs full program sign-ups
SELECT program_type, COUNT(*) AS signups, SUM(amount) AS revenue
FROM program_signups
WHERE signup_date BETWEEN '2024-01-01' AND '2025-12-31'
GROUP BY program_type;  -- program_type = 'Trial' or 'Full'

-- iii. Monthly students onboarded
SELECT DATE_TRUNC('month', created_at) AS month,
       COUNT(user_id) AS students_onboarded
FROM users
GROUP BY DATE_TRUNC('month', created_at);

-- iv. Workshop revenue (₹3999 per seat, tracked from Razorpay)
SELECT DATE_TRUNC('month', payment_date) AS month,
       COUNT(*) AS seats_sold,
       COUNT(*) * 3999 AS workshop_revenue
FROM workshop_payments
GROUP BY DATE_TRUNC('month', payment_date);

-- v. Program vs Workshop revenue tracking
SELECT category, SUM(amount) AS total_revenue
FROM revenue
GROUP BY category;  -- category = 'Program' or 'Workshop'

-- vi. Invoice generated but not paid
SELECT COUNT(*) AS unpaid_invoices, SUM(amount) AS pending_amount
FROM invoices
WHERE status = 'Unpaid';

-- vii. Renewals coming up for 3-month trial teens
SELECT user_id, renewal_date
FROM program_signups
WHERE program_type = 'Trial'
  AND renewal_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days';




--Funnel Journey (Meta Ads)
-- i. Funnel stages: Leads → Qualified → Discovery → Interview → Architect
SELECT COUNT(*) FILTER (WHERE stage = 'Lead') AS total_leads,
       COUNT(*) FILTER (WHERE stage = 'Qualified') AS qualified_leads,
       COUNT(*) FILTER (WHERE stage = 'Discovery') AS discovery_calls,
       COUNT(*) FILTER (WHERE stage = 'Interview') AS ambition_interviews,
       COUNT(*) FILTER (WHERE stage = 'Architect') AS architect_sessions
FROM funnel;

-- Show-up rate for discovery calls
SELECT COUNT(*) FILTER (WHERE attended = TRUE) * 100.0 / COUNT(*) AS show_up_rate
FROM funnel
WHERE stage = 'Discovery';

-- Drop-off rate for ambition interviews
SELECT COUNT(*) FILTER (WHERE completed = TRUE) * 100.0 / COUNT(*) AS interview_completion_rate
FROM funnel
WHERE stage = 'Interview';

-- ii. Top metrics
-- Cost of qualified leads
SELECT SUM(spend) / COUNT(*) AS cost_per_qualified_lead
FROM ad_spend
JOIN funnel ON ad_spend.lead_id = funnel.lead_id
WHERE funnel.stage = 'Qualified';

-- Program conversion %
SELECT COUNT(*) FILTER (WHERE stage = 'Architect' AND converted = TRUE) * 100.0 / COUNT(*) AS conversion_rate
FROM funnel;

-- Organic lead count
SELECT COUNT(*) AS organic_leads
FROM funnel
WHERE source = 'Organic';

-- Average lead journey duration
SELECT AVG(DATE_PART('day', end_date - start_date)) AS avg_lead_journey_days
FROM funnel
WHERE converted = TRUE OR dropped = TRUE;



--Campaign Performance
-- i. Assets with highest CTRs
SELECT asset_id, asset_name,
       COUNT(clicks) * 100.0 / COUNT(impressions) AS ctr_percent
FROM campaign_assets
GROUP BY asset_id, asset_name
ORDER BY ctr_percent DESC;

-- ii. Frequency of ad set (3+ means refresh needed)
SELECT ad_set_id, COUNT(*) AS frequency
FROM ad_impressions
GROUP BY ad_set_id
HAVING COUNT(*) >= 3;

-- iii. Landing page health (drop-off rate, loading time)
SELECT page_url,
       COUNT(*) FILTER (WHERE completed = FALSE) * 100.0 / COUNT(*) AS drop_off_rate,
       AVG(load_time_ms) AS avg_load_time
FROM landing_page_metrics
GROUP BY page_url;


--RCA
-- Campaigns to drop (low CTR, high spend, low conversion)
SELECT c.campaign_name,
       SUM(spend) AS total_spend,
       COUNT(clicks) * 100.0 / COUNT(impressions) AS ctr_percent,
       COUNT(*) FILTER (WHERE converted = TRUE) * 100.0 / COUNT(*) AS conversion_rate
FROM campaigns c
JOIN campaign_engagement ce ON c.campaign_id = ce.campaign_id
GROUP BY c.campaign_name
HAVING ctr_percent < 5 AND conversion_rate < 10;

-- Campaigns to refresh (CTR declining over time)
SELECT campaign_name,
       DATE_TRUNC('week', engagement_date) AS week,
       COUNT(clicks) * 100.0 / COUNT(impressions) AS ctr_percent
FROM campaign_engagement
GROUP BY campaign_name, DATE_TRUNC('week', engagement_date)
ORDER BY campaign_name, week;

-- Campaigns to scale (high CTR, high conversion)
SELECT c.campaign_name,
       COUNT(clicks) * 100.0 / COUNT(impressions) AS ctr_percent,
       COUNT(*) FILTER (WHERE converted = TRUE) * 100.0 / COUNT(*) AS conversion_rate
FROM campaigns c
JOIN campaign_engagement ce ON c.campaign_id = ce.campaign_id
GROUP BY c.campaign_name
HAVING ctr_percent > 15 AND conversion_rate > 20;
