-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    advisor_id INT,
    created_at DATE
);

-- Advisors table
CREATE TABLE advisors (
    advisor_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(100)
);

-- Sessions table
CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    session_duration INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Feature usage
CREATE TABLE feature_usage (
    usage_id INT PRIMARY KEY,
    user_id INT,
    feature_name VARCHAR(50),
    usage_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Notifications
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY,
    user_id INT,
    sent_at TIMESTAMP,
    opened_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Syllabus progress
CREATE TABLE syllabus_progress (
    progress_id INT PRIMARY KEY,
    user_id INT,
    subject VARCHAR(100),
    chapter VARCHAR(100),
    completion_percent INT,
    updated_at DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Campaigns
CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    channel VARCHAR(50)
);

-- Campaign engagement
CREATE TABLE campaign_engagement (
    engagement_id INT PRIMARY KEY,
    campaign_id INT,
    user_id INT,
    clicked BOOLEAN,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

--Revenue
CREATE TABLE revenue_actual (
    revenue_id INT PRIMARY KEY,
    user_id INT,
    category VARCHAR(50),       -- Program / Workshop
    program_type VARCHAR(50),   -- Trial / Full
    payment_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

--Revenue Targets
CREATE TABLE revenue_targets (
    target_id INT PRIMARY KEY,
    category VARCHAR(50),
    target_month DATE,
    target_amount DECIMAL(10,2)
);

--Invoices
CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


--Workshop payments
CREATE TABLE IF NOT EXISTS workshop_payments (
  payment_id INT PRIMARY KEY,
  user_id INT REFERENCES users(user_id),
  payment_date DATE,
  seats_sold INT,
  amount DECIMAL(12,2)


--Leads
CREATE TABLE leads (
    lead_id INT PRIMARY KEY,
    lead_name VARCHAR(100),
    source VARCHAR(50),              -- 'Meta Ads', 'Organic', 'Referral'
    status VARCHAR(50),              -- 'New', 'Qualified', 'Converted', 'Dropped'
    stage VARCHAR(50),               -- 'Discovery Call', 'Ambition Interview', 'Architect Session'
    first_contact_date DATE,
    conversion_or_drop_date DATE NULL,
    campaign_id INT NULL,
    spend DECIMAL(10,2) NULL,        -- ad spend for Meta campaigns
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

--Campaign Metrics
CREATE TABLE campaign_metrics (
    metric_id INT PRIMARY KEY,
    campaign_id INT,
    asset_name VARCHAR(100),          -- e.g. 'Video A', 'Image X', 'Ad Copy 1'
    impressions INT,
    clicks INT,
    frequency DECIMAL(5,2),
    spend DECIMAL(10,2),
    date DATE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

--Landing Page
CREATE TABLE landing_page (
    page_id INT PRIMARY KEY,
    campaign_id INT,
    page_name VARCHAR(100),
    visits INT,
    exits INT,
    conversions INT,
    load_time DECIMAL(5,2),           -- seconds
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);
