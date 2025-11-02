-- =====================================================
-- Luong's Productivity Hub - Supabase Database Schema
-- =====================================================
-- This schema supports:
-- 1. Task Management System (monthly-task-manager.html)
-- 2. Chinese Learning App (enhanced-chinese-app.html)
-- 3. User preferences and settings
-- 4. Cross-device synchronization
-- =====================================================
-- NOTE: Supabase automatically handles JWT secrets and RLS
-- No need to manually configure database-level settings
-- =====================================================

-- =====================================================
-- 1. USERS TABLE (extends Supabase auth.users)
-- =====================================================
CREATE TABLE public.user_profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    username TEXT UNIQUE,
    display_name TEXT,
    email TEXT,
    timezone TEXT DEFAULT 'UTC',
    language_preference TEXT DEFAULT 'en',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_profiles
CREATE POLICY "Users can view own profile" ON public.user_profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.user_profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.user_profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- =====================================================
-- 2. TASKS TABLE (Task Management System)
-- =====================================================
-- NOTE: Using TEXT for id to support timestamp-based IDs from the app
CREATE TABLE public.tasks (
    id TEXT PRIMARY KEY,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,

    -- Task Details
    title TEXT NOT NULL,
    description TEXT,
    priority TEXT CHECK (priority IN ('low', 'medium', 'high')) DEFAULT 'medium',
    frequency TEXT CHECK (frequency IN ('once', 'daily', 'weekly', 'monthly')) DEFAULT 'once',

    -- Dates and Times
    deadline DATE NOT NULL,
    time TIME,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    next_due TIMESTAMP WITH TIME ZONE,

    -- Status
    completed BOOLEAN DEFAULT FALSE,

    -- Metadata
    original_task_id TEXT, -- For recurring tasks, reference to original
    recurrence_count INTEGER DEFAULT 0,

    -- Indexes for performance
    CONSTRAINT valid_deadline CHECK (deadline >= CURRENT_DATE - INTERVAL '1 year')
);

-- Indexes for better performance
CREATE INDEX idx_tasks_user_id ON public.tasks(user_id);
CREATE INDEX idx_tasks_deadline ON public.tasks(deadline);
CREATE INDEX idx_tasks_next_due ON public.tasks(next_due);
CREATE INDEX idx_tasks_completed ON public.tasks(completed);
CREATE INDEX idx_tasks_frequency ON public.tasks(frequency);

-- Enable RLS
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policies for tasks
CREATE POLICY "Users can manage own tasks" ON public.tasks
    FOR ALL USING (auth.uid() = user_id);

-- =====================================================
-- 3. CHINESE VOCABULARY TABLE
-- =====================================================
CREATE TABLE public.chinese_vocabulary (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- Word Details
    chinese TEXT NOT NULL,
    pinyin TEXT,
    meaning TEXT,
    hsk_level TEXT,
    
    -- Learning Progress
    review_count INTEGER DEFAULT 0,
    correct_count INTEGER DEFAULT 0,
    last_reviewed TIMESTAMP WITH TIME ZONE,
    difficulty_level INTEGER DEFAULT 1 CHECK (difficulty_level BETWEEN 1 AND 5),
    
    -- Spaced Repetition Data
    next_review TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ease_factor DECIMAL(3,2) DEFAULT 2.50,
    interval_days INTEGER DEFAULT 1,
    
    -- Metadata
    date_added TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    source TEXT, -- Where the word was learned from
    notes TEXT,
    
    -- Ensure no duplicate words per user
    UNIQUE(user_id, chinese)
);

-- Indexes
CREATE INDEX idx_vocab_user_id ON public.chinese_vocabulary(user_id);
CREATE INDEX idx_vocab_hsk_level ON public.chinese_vocabulary(hsk_level);
CREATE INDEX idx_vocab_next_review ON public.chinese_vocabulary(next_review);
CREATE INDEX idx_vocab_difficulty ON public.chinese_vocabulary(difficulty_level);

-- Enable RLS
ALTER TABLE public.chinese_vocabulary ENABLE ROW LEVEL SECURITY;

-- RLS Policies for vocabulary
CREATE POLICY "Users can manage own vocabulary" ON public.chinese_vocabulary
    FOR ALL USING (auth.uid() = user_id);

-- =====================================================
-- 4. LEARNING SESSIONS TABLE (Chinese App Progress)
-- =====================================================
CREATE TABLE public.learning_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- Session Details
    session_date DATE DEFAULT CURRENT_DATE,
    session_type TEXT CHECK (session_type IN ('vocabulary', 'pinyin', 'flashcard', 'exercise')),
    duration_minutes INTEGER,
    
    -- Performance Metrics
    total_questions INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    accuracy_percentage DECIMAL(5,2),
    
    -- Progress Tracking
    words_learned INTEGER DEFAULT 0,
    words_reviewed INTEGER DEFAULT 0,
    streak_count INTEGER DEFAULT 0,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure one session per type per day per user
    UNIQUE(user_id, session_date, session_type)
);

-- Indexes
CREATE INDEX idx_sessions_user_date ON public.learning_sessions(user_id, session_date);
CREATE INDEX idx_sessions_type ON public.learning_sessions(session_type);

-- Enable RLS
ALTER TABLE public.learning_sessions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for learning sessions
CREATE POLICY "Users can manage own sessions" ON public.learning_sessions
    FOR ALL USING (auth.uid() = user_id);

-- =====================================================
-- 5. USER STATISTICS TABLE (Aggregated Stats)
-- =====================================================
CREATE TABLE public.user_statistics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE UNIQUE,
    
    -- Task Management Stats
    total_tasks_created INTEGER DEFAULT 0,
    total_tasks_completed INTEGER DEFAULT 0,
    current_task_streak INTEGER DEFAULT 0,
    longest_task_streak INTEGER DEFAULT 0,
    
    -- Chinese Learning Stats
    total_vocabulary_words INTEGER DEFAULT 0,
    total_learning_sessions INTEGER DEFAULT 0,
    current_learning_streak INTEGER DEFAULT 0,
    longest_learning_streak INTEGER DEFAULT 0,
    total_correct_answers INTEGER DEFAULT 0,
    total_questions_answered INTEGER DEFAULT 0,
    
    -- Celebration Stats
    total_celebrations INTEGER DEFAULT 0,
    last_celebration TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.user_statistics ENABLE ROW LEVEL SECURITY;

-- RLS Policies for statistics
CREATE POLICY "Users can manage own statistics" ON public.user_statistics
    FOR ALL USING (auth.uid() = user_id);

-- =====================================================
-- 6. APP SETTINGS TABLE (User Preferences)
-- =====================================================
CREATE TABLE public.app_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    
    -- Setting Details
    setting_key TEXT NOT NULL,
    setting_value JSONB,
    app_name TEXT CHECK (app_name IN ('task_manager', 'chinese_learning', 'global')),
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure unique settings per user per app
    UNIQUE(user_id, setting_key, app_name)
);

-- Indexes
CREATE INDEX idx_settings_user_app ON public.app_settings(user_id, app_name);
CREATE INDEX idx_settings_key ON public.app_settings(setting_key);

-- Enable RLS
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for settings
CREATE POLICY "Users can manage own settings" ON public.app_settings
    FOR ALL USING (auth.uid() = user_id);

-- =====================================================
-- 7. FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON public.tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_settings_updated_at BEFORE UPDATE ON public.app_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate next due date for recurring tasks
CREATE OR REPLACE FUNCTION calculate_next_due(
    deadline DATE,
    time_val TIME,
    frequency_val TEXT
) RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
    base_datetime TIMESTAMP WITH TIME ZONE;
    next_due TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Combine date and time
    base_datetime := deadline + COALESCE(time_val, '23:59:00'::TIME);
    
    -- Calculate next occurrence based on frequency
    CASE frequency_val
        WHEN 'daily' THEN
            next_due := base_datetime + INTERVAL '1 day';
        WHEN 'weekly' THEN
            next_due := base_datetime + INTERVAL '1 week';
        WHEN 'monthly' THEN
            next_due := base_datetime + INTERVAL '1 month';
        ELSE
            next_due := base_datetime;
    END CASE;
    
    RETURN next_due;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 8. INITIAL DATA AND VIEWS
-- =====================================================

-- View for active tasks (not completed, due soon)
CREATE VIEW active_tasks AS
SELECT 
    t.*,
    CASE 
        WHEN t.next_due < NOW() AND NOT t.completed THEN 'overdue'
        WHEN t.next_due < NOW() + INTERVAL '24 hours' AND NOT t.completed THEN 'due_soon'
        WHEN t.next_due < NOW() + INTERVAL '7 days' AND NOT t.completed THEN 'due_this_week'
        ELSE 'future'
    END as urgency_status
FROM public.tasks t
WHERE NOT t.completed
ORDER BY t.next_due ASC;

-- View for learning progress
CREATE VIEW learning_progress AS
SELECT 
    u.id as user_id,
    u.display_name,
    COUNT(v.id) as total_vocabulary,
    COUNT(CASE WHEN v.review_count > 0 THEN 1 END) as reviewed_words,
    AVG(CASE WHEN v.review_count > 0 THEN v.correct_count::DECIMAL / v.review_count ELSE 0 END) as avg_accuracy,
    MAX(s.streak_count) as current_streak
FROM public.user_profiles u
LEFT JOIN public.chinese_vocabulary v ON u.id = v.user_id
LEFT JOIN public.learning_sessions s ON u.id = s.user_id
GROUP BY u.id, u.display_name;

-- =====================================================
-- 9. SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Insert sample user profile (will be created automatically via Supabase Auth)
-- INSERT INTO public.user_profiles (id, username, display_name, email, timezone)
-- VALUES (
--     'sample-uuid-here',
--     'luong',
--     'Luong',
--     'luong@example.com',
--     'Asia/Ho_Chi_Minh'
-- );

-- =====================================================
-- END OF SCHEMA
-- =====================================================
