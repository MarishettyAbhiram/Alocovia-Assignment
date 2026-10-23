-- Users 2025: create 300 users (IDs 201..500)
INSERT INTO users (user_id, name, email, advisor_id, created_at)
SELECT g,
       'Student_' || g,
       'student' || g || '@example.com',
       CASE WHEN (g % 5) = 0 THEN 10 WHEN (g % 5) = 1 THEN 11 WHEN (g % 5) = 2 THEN 12 WHEN (g % 5) = 3 THEN 13 ELSE 14 END,
       DATE '2025-01-01' + ((g - 201) * INTERVAL '1 day')
FROM generate_series(201, 500) g;

-- Sessions 2025: ~1200 sessions
INSERT INTO sessions (session_id, user_id, start_time, end_time, session_duration)
SELECT 200000 + g,
       201 + ((g % 300)),
       (DATE '2025-01-01' + (g % 365) * INTERVAL '1 day') + (floor(random()*12)::int || ' hours')::interval,
       (DATE '2025-01-01' + (g % 365) * INTERVAL '1 day') + ((floor(random()*12)::int + 1) || ' hours')::interval + (floor(random()*50)::int || ' minutes')::interval,
       (30 + floor(random()*60))::int
FROM generate_series(1,1200) g;

-- Feature usage 2025: ~1500 rows
INSERT INTO feature_usage (usage_id, user_id, feature_name, usage_date)
SELECT 300000 + g,
       201 + ((g % 300)),
       (ARRAY['Realm','Focus Timer','Wellness','Goals','Notes','Practice'])[ceil(random()*6)],
       DATE '2025-01-01' + (g % 365) * INTERVAL '1 day'
FROM generate_series(1,1500) g;

-- Notifications 2025: ~800 rows
INSERT INTO notifications (notification_id, user_id, sent_at, opened_at)
SELECT 400000 + g,
       201 + ((g % 300)),
       (DATE '2025-01-01' + (g % 365) * INTERVAL '1 day') + (floor(random()*24)::int || ' hours')::interval,
       CASE WHEN random() > 0.35 THEN (DATE '2025-01-01' + (g % 365) * INTERVAL '1 day') + (floor(random()*24)::int || ' hours')::interval + (floor(random()*60)::int || ' minutes')::interval ELSE NULL END
FROM generate_series(1,800) g;

-- Syllabus progress 2025: ~300 rows
INSERT INTO syllabus_progress (progress_id, user_id, subject, chapter, completion_percent, updated_at)
SELECT 500000 + g,
       201 + ((g % 300)),
       (ARRAY['Math','CS','Physics','Chemistry','Biology'])[ceil(random()*5)],
       'Chapter_' || (1 + floor(random()*12)::int),
       (floor(random()*101))::int,
       DATE '2025-01-01' + (g % 365) * INTERVAL '1 day'
FROM generate_series(1,300) g;

-- Campaigns 2025: create a few campaigns
INSERT INTO campaigns (campaign_id, campaign_name, start_date, end_date, channel) VALUES
(9001, 'Social Media Push 2025 Q1', '2025-01-01', '2025-03-31', 'Instagram'),
(9002, 'Search Ads 2025 Q2', '2025-04-01', '2025-06-30', 'Google'),
(9003, 'Advisor Outreach 2025', '2025-07-01', '2025-09-30', 'Email');

-- Campaign engagement 2025: ~1000 rows
INSERT INTO campaign_engagement (engagement_id, campaign_id, user_id, clicked)
SELECT 600000 + g,
       CASE WHEN random() < 0.4 THEN 9001 WHEN random() < 0.7 THEN 9002 ELSE 9003 END,
       201 + ((g % 300)),
       random() > 0.6
FROM generate_series(1,1000) g;

-- Revenue actuals 2025: ~600 payments (mix of program/workshop)
INSERT INTO revenue_actual (revenue_id, user_id, category, program_type, payment_date, amount)
SELECT 700000 + g,
       201 + ((g % 300)),
       CASE WHEN random() < 0.75 THEN 'Program' ELSE 'Workshop' END,
       CASE WHEN random() < 0.75 THEN (CASE WHEN random() < 0.5 THEN 'Trial' ELSE 'Full' END) ELSE NULL END,
       DATE '2025-01-01' + (g % 365) * INTERVAL '1 day',
       CASE
         WHEN random() < 0.75 AND random() < 0.5 THEN 15000 + floor(random()*10000)::int
         WHEN random() < 0.75 THEN 40000 + floor(random()*20000)::int
         ELSE (3999 * (1 + floor(random()*3)))::numeric
       END
FROM generate_series(1,600) g;

-- Revenue targets 2025: monthly targets for Program and Workshop
INSERT INTO revenue_targets (target_id, category, target_month, target_amount)
SELECT 800000 + row_number() OVER (),
       cat,
       month::date,
       CASE WHEN cat = 'Program' THEN (30000 + (floor(random()*40000))::int) ELSE (5000 + (floor(random()*15000))::int) END
FROM (
  SELECT (date_trunc('month', (DATE '2025-01-01' + (n || ' months')::interval))) AS month, unnest(ARRAY['Program','Workshop']) AS cat
  FROM generate_series(0,11) n
) s;

-- Invoices 2025: ~250 invoices with some unpaid
INSERT INTO invoices (invoice_id, user_id, amount, status)
SELECT 900000 + g,
       201 + ((g % 300)),
       CASE WHEN random() < 0.8 THEN (15000 + floor(random()*35000))::numeric ELSE (3999 * (1 + floor(random()*2)))::numeric END,
       CASE WHEN random() < 0.75 THEN 'Paid' ELSE 'Unpaid' END
FROM generate_series(1,250) g;

-- Workshop payments 2025: ~200 rows
INSERT INTO workshop_payments (payment_id, user_id, payment_date, seats_sold, amount)
SELECT 1000000 + g,
       201 + ((g % 300)),
       DATE '2025-01-01' + (g % 365) * INTERVAL '1 day',
       1 + floor(random()*5)::int,
       (3999 * (1 + floor(random()*5)))::numeric
FROM generate_series(1,200) g;


-- Users 2026: create 300 users (IDs 501..800)
INSERT INTO users (user_id, name, email, advisor_id, created_at)
SELECT g,
       'Student_' || g,
       'student' || g || '@example.com',
       CASE WHEN (g % 5) = 0 THEN 10 WHEN (g % 5) = 1 THEN 11 WHEN (g % 5) = 2 THEN 12 WHEN (g % 5) = 3 THEN 13 ELSE 14 END,
       DATE '2026-01-01' + ((g - 501) * INTERVAL '1 day')
FROM generate_series(501, 800) g;

-- Sessions 2026: ~1400 sessions
INSERT INTO sessions (session_id, user_id, start_time, end_time, session_duration)
SELECT 300000 + g,
       501 + ((g % 300)),
       (DATE '2026-01-01' + (g % 365) * INTERVAL '1 day') + (floor(random()*12)::int || ' hours')::interval,
       (DATE '2026-01-01' + (g % 365) * INTERVAL '1 day') + ((floor(random()*12)::int + 1) || ' hours')::interval + (floor(random()*50)::int || ' minutes')::interval,
       (20 + floor(random()*70))::int
FROM generate_series(1,1400) g;

-- Feature usage 2026: ~1600 rows
INSERT INTO feature_usage (usage_id, user_id, feature_name, usage_date)
SELECT 400000 + g,
       501 + ((g % 300)),
       (ARRAY['Realm','Focus Timer','Wellness','Goals','Notes','Practice'])[ceil(random()*6)],
       DATE '2026-01-01' + (g % 365) * INTERVAL '1 day'
FROM generate_series(1,1600) g;

-- Notifications 2026: ~900 rows
INSERT INTO notifications (notification_id, user_id, sent_at, opened_at)
SELECT 500000 + g,
       501 + ((g % 300)),
       (DATE '2026-01-01' + (g % 365) * INTERVAL '1 day') + (floor(random()*24)::int || ' hours')::interval,
       CASE WHEN random() > 0.33 THEN (DATE '2026-01-01' + (g % 365) * INTERVAL '1 day') + (floor(random()*24)::int || ' hours')::interval + (floor(random()*60)::int || ' minutes')::interval ELSE NULL END
FROM generate_series(1,900) g;

-- Syllabus progress 2026: ~350 rows
INSERT INTO syllabus_progress (progress_id, user_id, subject, chapter, completion_percent, updated_at)
SELECT 600000 + g,
       501 + ((g % 300)),
       (ARRAY['Math','CS','Physics','Chemistry','Biology'])[ceil(random()*5)],
       'Chapter_' || (1 + floor(random()*12)::int),
       (floor(random()*101))::int,
       DATE '2026-01-01' + (g % 365) * INTERVAL '1 day'
FROM generate_series(1,350) g;

-- Campaigns 2026: a few campaigns
INSERT INTO campaigns (campaign_id, campaign_name, start_date, end_date, channel) VALUES
(9101, 'Social Media Push 2026 Q1', '2026-01-01', '2026-03-31', 'Instagram'),
(9102, 'Search Ads 2026 Q2', '2026-04-01', '2026-06-30', 'Google'),
(9103, 'Advisor Outreach 2026', '2026-07-01', '2026-09-30', 'Email');

-- Campaign engagement 2026: ~1100 rows
INSERT INTO campaign_engagement (engagement_id, campaign_id, user_id, clicked)
SELECT 700000 + g,
       CASE WHEN random() < 0.4 THEN 9101 WHEN random() < 0.7 THEN 9102 ELSE 9103 END,
       501 + ((g % 300)),
       random() > 0.55
FROM generate_series(1,1100) g;

-- Revenue actuals 2026: ~700 payments
INSERT INTO revenue_actual (revenue_id, user_id, category, program_type, payment_date, amount)
SELECT 800000 + g,
       501 + ((g % 300)),
       CASE WHEN random() < 0.72 THEN 'Program' ELSE 'Workshop' END,
       CASE WHEN random() < 0.72 THEN (CASE WHEN random() < 0.45 THEN 'Trial' ELSE 'Full' END) ELSE NULL END,
       DATE '2026-01-01' + (g % 365) * INTERVAL '1 day',
       CASE
         WHEN random() < 0.72 AND random() < 0.45 THEN 16000 + floor(random()*12000)::int
         WHEN random() < 0.72 THEN 42000 + floor(random()*25000)::int
         ELSE (3999 * (1 + floor(random()*4)))::numeric
       END
FROM generate_series(1,700) g;

-- Revenue targets 2026: monthly targets for Program and Workshop
INSERT INTO revenue_targets (target_id, category, target_month, target_amount)
SELECT 900000 + row_number() OVER (),
       cat,
       month::date,
       CASE WHEN cat = 'Program' THEN (35000 + (floor(random()*45000))::int) ELSE (6000 + (floor(random()*16000))::int) END
FROM (
  SELECT (date_trunc('month', (DATE '2026-01-01' + (n || ' months')::interval))) AS month, unnest(ARRAY['Program','Workshop']) AS cat
  FROM generate_series(0,11) n
) s;

-- Invoices 2026: ~300 invoices
INSERT INTO invoices (invoice_id, user_id, amount, status)
SELECT 1000000 + g,
       501 + ((g % 300)),
       CASE WHEN random() < 0.8 THEN (16000 + floor(random()*38000))::numeric ELSE (3999 * (1 + floor(random()*3)))::numeric END,
       CASE WHEN random() < 0.78 THEN 'Paid' ELSE 'Unpaid' END
FROM generate_series(1,300) g;

-- Workshop payments 2026: ~250 rows
INSERT INTO workshop_payments (payment_id, user_id, payment_date, seats_sold, amount)
SELECT 1100000 + g,
       501 + ((g % 300)),
       DATE '2026-01-01' + (g % 365) * INTERVAL '1 day',
       1 + floor(random()*6)::int,
       (3999 * (1 + floor(random()*6)))::numeric
FROM generate_series(1,250) g;


INSERT INTO leads (lead_id, lead_name, source, status, stage, first_contact_date, conversion_or_drop_date, campaign_id, spend)
VALUES
(1001, 'Lead_1001', 'Meta Ads', 'Qualified', 'Discovery Call', '2025-01-05', '2025-01-10', 9001, 75.00),
(1002, 'Lead_1002', 'Meta Ads', 'Qualified', 'Ambition Interview', '2025-01-07', '2025-01-15', 9001, 80.00),
(1003, 'Lead_1003', 'Meta Ads', 'Converted', 'Architect Session', '2025-01-10', '2025-01-20', 9001, 90.00),
(1004, 'Lead_1004', 'Organic', 'Dropped', 'Discovery Call', '2025-02-01', '2025-02-05', NULL, NULL),
(1005, 'Lead_1005', 'Meta Ads', 'Qualified', 'Ambition Interview', '2025-02-10', '2025-02-18', 9002, 70.00),
(1006, 'Lead_1006', 'Referral', 'Converted', 'Architect Session', '2025-03-01', '2025-03-10', NULL, NULL),
(1007, 'Lead_1007', 'Meta Ads', 'Dropped', 'Discovery Call', '2025-03-05', '2025-03-08', 9002, 60.00),
(1008, 'Lead_1008', 'Organic', 'Qualified', 'Ambition Interview', '2025-03-12', '2025-03-20', NULL, NULL),
(1009, 'Lead_1009', 'Meta Ads', 'Converted', 'Architect Session', '2025-03-15', '2025-03-25', 9003, 85.00),
(1010, 'Lead_1010', 'Meta Ads', 'Qualified', 'Discovery Call', '2025-04-01', '2025-04-05', 9003, 78.00);


INSERT INTO leads (lead_id, lead_name, source, status, stage, first_contact_date, conversion_or_drop_date, campaign_id, spend)
VALUES
(2001, 'Lead_2001', 'Meta Ads', 'Qualified', 'Discovery Call', '2026-01-05', '2026-01-10', 9101, 72.00),
(2002, 'Lead_2002', 'Meta Ads', 'Qualified', 'Ambition Interview', '2026-01-07', '2026-01-15', 9101, 76.00),
(2003, 'Lead_2003', 'Meta Ads', 'Converted', 'Architect Session', '2026-01-10', '2026-01-20', 9101, 88.00),
(2004, 'Lead_2004', 'Organic', 'Dropped', 'Discovery Call', '2026-02-01', '2026-02-05', NULL, NULL),
(2005, 'Lead_2005', 'Meta Ads', 'Qualified', 'Ambition Interview', '2026-02-10', '2026-02-18', 9102, 70.00),
(2006, 'Lead_2006', 'Referral', 'Converted', 'Architect Session', '2026-03-01', '2026-03-10', NULL, NULL),
(2007, 'Lead_2007', 'Meta Ads', 'Dropped', 'Discovery Call', '2026-03-05', '2026-03-08', 9102, 65.00),
(2008, 'Lead_2008', 'Organic', 'Qualified', 'Ambition Interview', '2026-03-12', '2026-03-20', NULL, NULL),
(2009, 'Lead_2009', 'Meta Ads', 'Converted', 'Architect Session', '2026-03-15', '2026-03-25', 9103, 82.00),
(2010, 'Lead_2010', 'Meta Ads', 'Qualified', 'Discovery Call', '2026-04-01', '2026-04-05', 9103, 75.00);


-- Generate 300 synthetic campaign metrics for 2025
INSERT INTO campaign_metrics (metric_id, campaign_id, asset_name, impressions, clicks, frequency, spend, date)
SELECT 700000 + g,
       CASE WHEN g % 3 = 0 THEN 9001 WHEN g % 3 = 1 THEN 9002 ELSE 9003 END,
       'Asset_' || g,
       8000 + (g % 5000),                          -- impressions
       100 + (g % 900),                            -- clicks
       ROUND(2.0 + (random() * 2)::numeric,2),     -- frequency between 2.0–4.0
       ROUND(400 + (random() * 300)::numeric,2),   -- spend between 400–700
       DATE '2025-01-01' + (g % 365) * INTERVAL '1 day'
FROM generate_series(1,300) g;

-- Generate 300 synthetic campaign metrics for 2026
INSERT INTO campaign_metrics (metric_id, campaign_id, asset_name, impressions, clicks, frequency, spend, date)
SELECT 800000 + g,
       CASE WHEN g % 3 = 0 THEN 9101 WHEN g % 3 = 1 THEN 9102 ELSE 9103 END,
       'Asset_' || g,
       8500 + (g % 5500),
       120 + (g % 950),
       ROUND(2.0 + (random() * 2)::numeric,2),
       ROUND(420 + (random() * 320)::numeric,2),
       DATE '2026-01-01' + (g % 365) * INTERVAL '1 day'
FROM generate_series(1,300) g;


-- Generate 120 synthetic landing page records for 2025
INSERT INTO landing_page (page_id, campaign_id, page_name, visits, exits, conversions, load_time)
SELECT 900000 + g,
       CASE WHEN g % 3 = 0 THEN 9001 WHEN g % 3 = 1 THEN 9002 ELSE 9003 END,
       'Landing_' || g,
       3000 + (g % 2500),                          -- visits
       1500 + (g % 1200),                          -- exits
       300 + (g % 700),                            -- conversions
       ROUND(3.0 + (random() * 1.5)::numeric,2)   -- load time between 3.0–4.5 sec
FROM generate_series(1,120) g;

-- Generate 120 synthetic landing page records for 2026
INSERT INTO landing_page (page_id, campaign_id, page_name, visits, exits, conversions, load_time)
SELECT 910000 + g,
       CASE WHEN g % 3 = 0 THEN 9101 WHEN g % 3 = 1 THEN 9102 ELSE 9103 END,
       'Landing_' || g,
       3200 + (g % 2600),
       1600 + (g % 1300),
       320 + (g % 750),
       ROUND(3.0 + (random() * 1.5)::numeric,2)
FROM generate_series(1,120) g;
