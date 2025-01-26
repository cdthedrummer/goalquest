-- Create enum types for categories and status
CREATE TYPE attribute_category AS ENUM (
    'strength',
    'dexterity',
    'constitution',
    'intelligence',
    'wisdom',
    'charisma'
);

CREATE TYPE goal_status AS ENUM (
    'not_started',
    'in_progress',
    'completed',
    'abandoned'
);

-- Create profiles table
CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users NOT NULL UNIQUE,
    username TEXT UNIQUE,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create quiz_results table
CREATE TABLE quiz_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users NOT NULL,
    strength INTEGER CHECK (strength BETWEEN 0 AND 20),
    dexterity INTEGER CHECK (dexterity BETWEEN 0 AND 20),
    constitution INTEGER CHECK (constitution BETWEEN 0 AND 20),
    intelligence INTEGER CHECK (intelligence BETWEEN 0 AND 20),
    wisdom INTEGER CHECK (wisdom BETWEEN 0 AND 20),
    charisma INTEGER CHECK (charisma BETWEEN 0 AND 20),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT valid_stats CHECK (
        strength IS NOT NULL AND
        dexterity IS NOT NULL AND
        constitution IS NOT NULL AND
        intelligence IS NOT NULL AND
        wisdom IS NOT NULL AND
        charisma IS NOT NULL
    )
);

-- Create goals table
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    category attribute_category NOT NULL,
    difficulty INTEGER CHECK (difficulty BETWEEN 1 AND 3),
    status goal_status DEFAULT 'not_started',
    target_value NUMERIC,
    current_value NUMERIC DEFAULT 0,
    start_date DATE,
    target_date DATE,
    completed_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create progress_updates table for tracking goal progress
CREATE TABLE progress_updates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    goal_id UUID REFERENCES goals NOT NULL,
    previous_value NUMERIC,
    new_value NUMERIC NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add RLS (Row Level Security) policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_updates ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone" ON profiles
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile" ON profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Quiz results policies
CREATE POLICY "Users can view their own quiz results" ON quiz_results
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own quiz results" ON quiz_results
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Goals policies
CREATE POLICY "Users can view their own goals" ON goals
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own goals" ON goals
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own goals" ON goals
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own goals" ON goals
    FOR DELETE USING (auth.uid() = user_id);

-- Progress updates policies
CREATE POLICY "Users can view their own progress updates" ON progress_updates
    FOR SELECT USING (
        auth.uid() = (SELECT user_id FROM goals WHERE id = progress_updates.goal_id)
    );

CREATE POLICY "Users can insert progress updates for their goals" ON progress_updates
    FOR INSERT WITH CHECK (
        auth.uid() = (SELECT user_id FROM goals WHERE id = goal_id)
    );

-- Create indexes for better query performance
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_quiz_results_user_id ON quiz_results(user_id);
CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_goals_category ON goals(category);
CREATE INDEX idx_goals_status ON goals(status);
CREATE INDEX idx_progress_updates_goal_id ON progress_updates(goal_id);

-- Function to update goals updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_goals_updated_at
    BEFORE UPDATE ON goals
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();