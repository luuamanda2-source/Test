-- =====================================================
-- Migration: Update tasks table to use TEXT IDs
-- =====================================================
-- This migration updates the tasks table to support
-- timestamp-based TEXT IDs instead of UUIDs
-- Run this in your Supabase SQL Editor
-- =====================================================

-- Step 1: Drop existing tasks table if it exists
-- WARNING: This will delete all existing tasks!
-- Make sure to backup your data first!
DROP TABLE IF EXISTS public.tasks CASCADE;

-- Step 2: Recreate tasks table with TEXT id
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

-- Step 3: Recreate indexes
CREATE INDEX idx_tasks_user_id ON public.tasks(user_id);
CREATE INDEX idx_tasks_deadline ON public.tasks(deadline);
CREATE INDEX idx_tasks_next_due ON public.tasks(next_due);
CREATE INDEX idx_tasks_completed ON public.tasks(completed);
CREATE INDEX idx_tasks_frequency ON public.tasks(frequency);

-- Step 4: Enable RLS
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- Step 5: Recreate RLS policies
CREATE POLICY "Users can manage own tasks" ON public.tasks
    FOR ALL USING (auth.uid() = user_id);

-- Step 6: Recreate trigger for updated_at
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON public.tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Step 7: Recreate the active_tasks view
DROP VIEW IF EXISTS active_tasks;
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

-- =====================================================
-- Migration Complete!
-- =====================================================
-- Your tasks table now supports TEXT IDs
-- You can now use the task manager with cloud sync
-- =====================================================

