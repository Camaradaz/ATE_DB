-- Enable Row Level Security for all tables
ALTER TABLE sectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliates ENABLE ROW LEVEL SECURITY;
ALTER TABLE children ENABLE ROW LEVEL SECURITY;
ALTER TABLE affiliate_history ENABLE ROW LEVEL SECURITY;

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

-- Create policies for affiliate_history
CREATE POLICY "Enable read access for authenticated users" ON affiliate_history
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Enable insert access for authenticated users" ON affiliate_history
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Enable update access for authenticated users" ON affiliate_history
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);
