-- Enable Row Level Security for all tables
ALTER TABLE sectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliates ENABLE ROW LEVEL SECURITY;
ALTER TABLE children ENABLE ROW LEVEL SECURITY;

-- Create policies for sectors
CREATE POLICY "Allow authenticated users to read sectors"
    ON sectors
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated users to insert sectors"
    ON sectors
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update sectors"
    ON sectors
    FOR UPDATE
    TO authenticated
    USING (true);

-- Create policies for affiliates
CREATE POLICY "Allow authenticated users to read affiliates"
    ON affiliates
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated users to insert affiliates"
    ON affiliates
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update affiliates"
    ON affiliates
    FOR UPDATE
    TO authenticated
    USING (true);

-- Create policies for children
CREATE POLICY "Allow authenticated users to read children"
    ON children
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated users to insert children"
    ON children
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update children"
    ON children
    FOR UPDATE
    TO authenticated
    USING (true);

-- Create indexes for better performance
-- Affiliates indexes
CREATE INDEX IF NOT EXISTS idx_affiliates_sector_id ON affiliates(sector_id);
CREATE INDEX IF NOT EXISTS idx_affiliates_dni ON affiliates(dni);
CREATE INDEX IF NOT EXISTS idx_affiliates_affiliate_code ON affiliates(affiliate_code);

-- Children indexes
CREATE INDEX IF NOT EXISTS idx_children_affiliate_id ON children(affiliate_id);
CREATE INDEX IF NOT EXISTS idx_children_dni ON children(dni);
CREATE INDEX IF NOT EXISTS idx_children_birth_date ON children(birth_date); 