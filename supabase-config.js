// =====================================================
// Supabase Configuration for Luong's Productivity Hub
// =====================================================

const SUPABASE_URL = 'https://kkbpztplpnaygfqmtimf.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrYnB6dHBscG5heWdmcW10aW1mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwODQ2MzYsImV4cCI6MjA3NzY2MDYzNn0.y4-_pRmDM0dCkNIilDpfp6tFkEOLk96PvSnSitVnTbM';

// Initialize Supabase client
let supabaseClient = null;

// Initialize function (called when Supabase library is loaded)
function initSupabase() {
    if (typeof supabase !== 'undefined') {
        supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
        console.log('✅ Supabase initialized successfully');
        return true;
    } else {
        console.error('❌ Supabase library not loaded');
        return false;
    }
}

// Check if user is authenticated
async function isAuthenticated() {
    if (!supabaseClient) return false;
    
    const { data: { session } } = await supabaseClient.auth.getSession();
    return session !== null;
}

// Get current user
async function getCurrentUser() {
    if (!supabaseClient) return null;
    
    const { data: { user } } = await supabaseClient.auth.getUser();
    return user;
}

// Sign up new user
async function signUp(email, password, displayName) {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const { data, error } = await supabaseClient.auth.signUp({
        email: email,
        password: password,
        options: {
            data: {
                display_name: displayName
            }
        }
    });
    
    if (error) throw error;
    
    // Create user profile
    if (data.user) {
        const { error: profileError } = await supabaseClient
            .from('user_profiles')
            .insert([{
                id: data.user.id,
                username: email.split('@')[0],
                display_name: displayName,
                email: email
            }]);
        
        if (profileError) console.error('Profile creation error:', profileError);
    }
    
    return data;
}

// Sign in existing user
async function signIn(email, password) {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const { data, error } = await supabaseClient.auth.signInWithPassword({
        email: email,
        password: password
    });
    
    if (error) throw error;
    return data;
}

// Sign out
async function signOut() {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const { error } = await supabaseClient.auth.signOut();
    if (error) throw error;
}

// =====================================================
// Task Management Functions
// =====================================================

// Save task to Supabase
async function saveTaskToSupabase(task) {
    if (!supabaseClient) throw new Error('Supabase not initialized');

    const user = await getCurrentUser();
    if (!user) throw new Error('User not authenticated');

    const taskData = {
        id: task.id, // Keep the string ID from the app
        user_id: user.id,
        title: task.title,
        description: task.description || '',
        priority: task.priority,
        frequency: task.frequency,
        deadline: task.deadline,
        time: task.time || null,
        completed: task.completed,
        completed_at: task.completedAt || null,
        next_due: task.nextDue,
        original_task_id: task.originalTaskId || null,
        recurrence_count: task.recurrenceCount || 0
    };

    // First try to update, if not exists then insert
    const { data: existingTask } = await supabaseClient
        .from('tasks')
        .select('id')
        .eq('id', task.id)
        .single();

    let result;
    if (existingTask) {
        // Update existing task
        result = await supabaseClient
            .from('tasks')
            .update(taskData)
            .eq('id', task.id)
            .select();
    } else {
        // Insert new task
        result = await supabaseClient
            .from('tasks')
            .insert([taskData])
            .select();
    }

    if (result.error) throw result.error;
    return result.data;
}

// Load all tasks from Supabase
async function loadTasksFromSupabase() {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const user = await getCurrentUser();
    if (!user) return [];
    
    const { data, error } = await supabaseClient
        .from('tasks')
        .select('*')
        .eq('user_id', user.id)
        .order('next_due', { ascending: true });
    
    if (error) throw error;
    
    // Convert to app format
    return data.map(task => ({
        id: task.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        frequency: task.frequency,
        deadline: task.deadline,
        time: task.time,
        completed: task.completed,
        createdAt: task.created_at,
        completedAt: task.completed_at,
        nextDue: task.next_due,
        originalTaskId: task.original_task_id,
        recurrenceCount: task.recurrence_count
    }));
}

// Delete task from Supabase
async function deleteTaskFromSupabase(taskId) {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const { error } = await supabaseClient
        .from('tasks')
        .delete()
        .eq('id', taskId);
    
    if (error) throw error;
}

// Sync all tasks to Supabase
async function syncTasksToSupabase(tasks) {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const user = await getCurrentUser();
    if (!user) throw new Error('User not authenticated');
    
    const tasksData = tasks.map(task => ({
        id: task.id,
        user_id: user.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        frequency: task.frequency,
        deadline: task.deadline,
        time: task.time || null,
        completed: task.completed,
        completed_at: task.completedAt || null,
        next_due: task.nextDue,
        original_task_id: task.originalTaskId || null,
        recurrence_count: task.recurrenceCount || 0
    }));
    
    const { data, error } = await supabaseClient
        .from('tasks')
        .upsert(tasksData, { onConflict: 'id' })
        .select();
    
    if (error) throw error;
    return data;
}

// =====================================================
// Chinese Vocabulary Functions
// =====================================================

// Save vocabulary to Supabase
async function saveVocabularyToSupabase(vocabulary) {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const user = await getCurrentUser();
    if (!user) throw new Error('User not authenticated');
    
    const vocabData = vocabulary.map(word => ({
        user_id: user.id,
        chinese: word.chinese,
        pinyin: word.pinyin,
        meaning: word.meaning,
        hsk_level: word.hskLevel,
        review_count: word.reviewCount || 0,
        correct_count: word.correctCount || 0,
        date_added: word.dateAdded
    }));
    
    const { data, error } = await supabaseClient
        .from('chinese_vocabulary')
        .upsert(vocabData, { onConflict: 'user_id,chinese' })
        .select();
    
    if (error) throw error;
    return data;
}

// Load vocabulary from Supabase
async function loadVocabularyFromSupabase() {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const user = await getCurrentUser();
    if (!user) return [];
    
    const { data, error } = await supabaseClient
        .from('chinese_vocabulary')
        .select('*')
        .eq('user_id', user.id)
        .order('date_added', { ascending: false });
    
    if (error) throw error;
    
    return data.map(word => ({
        chinese: word.chinese,
        pinyin: word.pinyin,
        meaning: word.meaning,
        hskLevel: word.hsk_level,
        reviewCount: word.review_count,
        correctCount: word.correct_count,
        dateAdded: word.date_added
    }));
}

// =====================================================
// User Statistics Functions
// =====================================================

// Update user statistics
async function updateUserStats(stats) {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const user = await getCurrentUser();
    if (!user) throw new Error('User not authenticated');
    
    const { data, error } = await supabaseClient
        .from('user_statistics')
        .upsert([{
            user_id: user.id,
            ...stats
        }], { onConflict: 'user_id' })
        .select();
    
    if (error) throw error;
    return data;
}

// Get user statistics
async function getUserStats() {
    if (!supabaseClient) throw new Error('Supabase not initialized');
    
    const user = await getCurrentUser();
    if (!user) return null;
    
    const { data, error } = await supabaseClient
        .from('user_statistics')
        .select('*')
        .eq('user_id', user.id)
        .single();
    
    if (error && error.code !== 'PGRST116') throw error; // PGRST116 = no rows
    return data;
}

// Export configuration
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        SUPABASE_URL,
        SUPABASE_ANON_KEY,
        initSupabase,
        isAuthenticated,
        getCurrentUser,
        signUp,
        signIn,
        signOut,
        saveTaskToSupabase,
        loadTasksFromSupabase,
        deleteTaskFromSupabase,
        syncTasksToSupabase,
        saveVocabularyToSupabase,
        loadVocabularyFromSupabase,
        updateUserStats,
        getUserStats
    };
}
