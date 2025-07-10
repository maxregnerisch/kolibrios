;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                            ;;
;; maxregnerOS Ultra-Fast Kernel Scheduler                                   ;;
;; Copyright (C) maxregnerOS team 2024. All rights reserved.                 ;;
;; Advanced scheduler optimized for ultra-fast I/O and low latency           ;;
;;                                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Ultra-Fast Scheduler Features:
; - Multi-level feedback queue with I/O awareness
; - Real-time scheduling for critical tasks
; - CPU affinity and NUMA awareness
; - Load balancing across cores
; - Interrupt coalescing and batching
; - Power-aware scheduling
; - Lock-free data structures where possible

; Scheduler priority levels
SCHED_PRIORITY_RT       = 0     ; Real-time priority
SCHED_PRIORITY_HIGH     = 1     ; High priority
SCHED_PRIORITY_NORMAL   = 2     ; Normal priority
SCHED_PRIORITY_LOW      = 3     ; Low priority
SCHED_PRIORITY_IDLE     = 4     ; Idle priority

; Task states
TASK_STATE_RUNNING      = 1
TASK_STATE_READY        = 2
TASK_STATE_BLOCKED      = 3
TASK_STATE_IO_WAIT      = 4
TASK_STATE_SLEEPING     = 5
TASK_STATE_ZOMBIE       = 6

; Ultra-fast task control block
struct ULTRA_TASK_BLOCK
    task_id             dd ?    ; Unique task identifier
    priority            dd ?    ; Current priority level
    base_priority       dd ?    ; Base priority (for priority inheritance)
    state               dd ?    ; Current task state
    cpu_affinity        dd ?    ; CPU affinity mask
    numa_node           dd ?    ; Preferred NUMA node
    
    ; CPU context
    esp                 dd ?    ; Stack pointer
    ebp                 dd ?    ; Base pointer
    eip                 dd ?    ; Instruction pointer
    eflags              dd ?    ; Flags register
    
    ; Scheduling information
    time_slice          dd ?    ; Remaining time slice
    total_runtime       dq ?    ; Total CPU time used
    last_scheduled      dq ?    ; Last scheduled timestamp
    sleep_until         dq ?    ; Sleep until timestamp
    
    ; I/O information
    io_priority         dd ?    ; I/O priority
    io_wait_count       dd ?    ; Number of I/O waits
    io_completion_cb    dd ?    ; I/O completion callback
    
    ; Performance tracking
    cache_misses        dd ?    ; Cache miss count
    context_switches    dd ?    ; Context switch count
    voluntary_switches  dd ?    ; Voluntary context switches
    
    ; Queue linkage
    next_task           dd ?    ; Next task in queue
    prev_task           dd ?    ; Previous task in queue
    
    ; Memory management
    page_directory      dd ?    ; Page directory address
    memory_usage        dd ?    ; Current memory usage
    
    ; Lock information
    locks_held          dd ?    ; Number of locks held
    lock_list           dd ?    ; List of held locks
ends

; Multi-level feedback queue
struct SCHED_QUEUE
    head                dd ?    ; First task in queue
    tail                dd ?    ; Last task in queue
    count               dd ?    ; Number of tasks in queue
    time_quantum        dd ?    ; Time quantum for this queue
    priority_level      dd ?    ; Priority level
    last_service        dq ?    ; Last service time
ends

; Per-CPU scheduler data
struct CPU_SCHEDULER_DATA
    current_task        dd ?    ; Currently running task
    idle_task           dd ?    ; Idle task for this CPU
    run_queues          dd 5 dup(?) ; Run queues for each priority
    load_average        dd ?    ; Load average for this CPU
    context_switches    dd ?    ; Context switches on this CPU
    interrupts_handled  dd ?    ; Interrupts handled
    cpu_utilization     dd ?    ; CPU utilization percentage
    last_balance        dq ?    ; Last load balance time
ends

; Global scheduler statistics
struct ULTRA_SCHED_STATS
    total_tasks         dd ?    ; Total number of tasks
    running_tasks       dd ?    ; Currently running tasks
    blocked_tasks       dd ?    ; Blocked tasks
    context_switches    dq ?    ; Total context switches
    avg_response_time   dd ?    ; Average response time (microseconds)
    avg_turnaround_time dd ?    ; Average turnaround time
    cpu_utilization     dd ?    ; Overall CPU utilization
    load_average_1min   dd ?    ; 1-minute load average
    load_average_5min   dd ?    ; 5-minute load average
    load_average_15min  dd ?    ; 15-minute load average
ends

; Global scheduler variables
cpu_scheduler_data      CPU_SCHEDULER_DATA
ultra_sched_stats       ULTRA_SCHED_STATS
scheduler_lock          dd 0
current_time_slice      dd 10   ; Default 10ms time slice
load_balance_interval   dd 100  ; Load balance every 100ms
numa_nodes              dd 0    ; Number of NUMA nodes
cpu_count               dd 1    ; Number of CPUs

; Time quantum for each priority level (in milliseconds)
time_quantums dd 5, 10, 20, 50, 100

; Initialize ultra-fast scheduler
align 4
proc ultra_scheduler_init
    pushad
    
    ; Initialize per-CPU scheduler data
    call init_per_cpu_scheduler
    
    ; Setup multi-level feedback queues
    call init_feedback_queues
    
    ; Initialize load balancing
    call init_load_balancing
    
    ; Setup interrupt coalescing
    call init_interrupt_coalescing
    
    ; Initialize performance monitoring
    call init_scheduler_stats
    
    ; Setup power management integration
    call init_power_aware_scheduling
    
    ; Create idle tasks for each CPU
    call create_idle_tasks
    
    popad
    ret
endp

; Initialize per-CPU scheduler data
align 4
proc init_per_cpu_scheduler
    pushad
    
    ; Get number of CPUs
    call get_cpu_count
    mov [cpu_count], eax
    
    ; Initialize scheduler data for each CPU
    mov ecx, eax
    mov esi, cpu_scheduler_data
    
.init_cpu_loop:
    push ecx
    
    ; Initialize run queues for this CPU
    mov edx, 5                  ; 5 priority levels
    lea edi, [esi + CPU_SCHEDULER_DATA.run_queues]
    
.init_queue_loop:
    push edx
    
    ; Allocate queue structure
    mov eax, sizeof.SCHED_QUEUE
    call ultra_alloc_fast
    test eax, eax
    jz .queue_init_failed
    
    mov [edi], eax
    mov ebx, eax
    
    ; Initialize queue
    mov [ebx + SCHED_QUEUE.head], 0
    mov [ebx + SCHED_QUEUE.tail], 0
    mov [ebx + SCHED_QUEUE.count], 0
    
    ; Set time quantum based on priority
    mov eax, 5
    sub eax, edx
    mov ecx, [time_quantums + eax * 4]
    mov [ebx + SCHED_QUEUE.time_quantum], ecx
    mov [ebx + SCHED_QUEUE.priority_level], eax
    
    add edi, 4
    pop edx
    dec edx
    jnz .init_queue_loop
    
    ; Initialize CPU-specific data
    mov [esi + CPU_SCHEDULER_DATA.current_task], 0
    mov [esi + CPU_SCHEDULER_DATA.load_average], 0
    mov [esi + CPU_SCHEDULER_DATA.context_switches], 0
    
    add esi, sizeof.CPU_SCHEDULER_DATA
    pop ecx
    loop .init_cpu_loop
    
    popad
    ret
    
.queue_init_failed:
    pop edx
    pop ecx
    popad
    ret
endp

; Ultra-fast task creation
align 4
proc ultra_create_task
; Input: esi = task entry point, edi = stack pointer, edx = priority
; Output: eax = task block pointer (0 if failed)
    
    pushad
    
    ; Allocate task control block
    mov eax, sizeof.ULTRA_TASK_BLOCK
    call ultra_alloc_fast
    test eax, eax
    jz .task_create_failed
    
    mov ebx, eax                ; Task block pointer
    
    ; Generate unique task ID
    call generate_task_id
    mov [ebx + ULTRA_TASK_BLOCK.task_id], eax
    
    ; Initialize task parameters
    mov [ebx + ULTRA_TASK_BLOCK.priority], edx
    mov [ebx + ULTRA_TASK_BLOCK.base_priority], edx
    mov [ebx + ULTRA_TASK_BLOCK.state], TASK_STATE_READY
    mov [ebx + ULTRA_TASK_BLOCK.esp], edi
    mov [ebx + ULTRA_TASK_BLOCK.eip], esi
    
    ; Set default CPU affinity (all CPUs)
    mov eax, -1
    mov [ebx + ULTRA_TASK_BLOCK.cpu_affinity], eax
    
    ; Initialize performance counters
    mov [ebx + ULTRA_TASK_BLOCK.cache_misses], 0
    mov [ebx + ULTRA_TASK_BLOCK.context_switches], 0
    
    ; Set time slice based on priority
    mov eax, [time_quantums + edx * 4]
    mov [ebx + ULTRA_TASK_BLOCK.time_slice], eax
    
    ; Add to appropriate run queue
    call add_task_to_runqueue
    
    ; Update statistics
    inc [ultra_sched_stats.total_tasks]
    
    popad
    mov eax, ebx
    ret
    
.task_create_failed:
    popad
    xor eax, eax
    ret
endp

; Ultra-fast context switch
align 4
proc ultra_context_switch
; Input: eax = current task, ebx = next task
    
    ; Save current task context
    test eax, eax
    jz .no_current_task
    
    ; Save registers
    mov [eax + ULTRA_TASK_BLOCK.esp], esp
    mov [eax + ULTRA_TASK_BLOCK.ebp], ebp
    pushfd
    pop ecx
    mov [eax + ULTRA_TASK_BLOCK.eflags], ecx
    
    ; Update task statistics
    inc [eax + ULTRA_TASK_BLOCK.context_switches]
    rdtsc
    mov [eax + ULTRA_TASK_BLOCK.last_scheduled], eax
    mov [eax + ULTRA_TASK_BLOCK.last_scheduled + 4], edx
    
.no_current_task:
    ; Switch to next task
    test ebx, ebx
    jz .no_next_task
    
    ; Load next task context
    mov esp, [ebx + ULTRA_TASK_BLOCK.esp]
    mov ebp, [ebx + ULTRA_TASK_BLOCK.ebp]
    mov ecx, [ebx + ULTRA_TASK_BLOCK.eflags]
    push ecx
    popfd
    
    ; Update current task pointer
    mov [cpu_scheduler_data.current_task], ebx
    
    ; Update statistics
    inc [ultra_sched_stats.context_switches]
    inc [cpu_scheduler_data.context_switches]
    
    ; Jump to task
    jmp [ebx + ULTRA_TASK_BLOCK.eip]
    
.no_next_task:
    ; No task to switch to, run idle task
    call run_idle_task
    ret
endp

; Advanced scheduling algorithm
align 4
proc ultra_schedule
    pushad
    
    ; Get current task
    mov eax, [cpu_scheduler_data.current_task]
    
    ; Check if current task should be preempted
    call should_preempt_current_task
    test eax, eax
    jz .no_preemption
    
    ; Find next task to run
    call find_next_task
    mov ebx, eax
    
    ; Check if we found a different task
    cmp ebx, [cpu_scheduler_data.current_task]
    je .no_context_switch
    
    ; Perform context switch
    mov eax, [cpu_scheduler_data.current_task]
    call ultra_context_switch
    
.no_context_switch:
.no_preemption:
    ; Update scheduler statistics
    call update_scheduler_stats
    
    popad
    ret
endp

; Find next task to run using multi-level feedback
align 4
proc find_next_task
; Output: eax = next task (0 if none)
    
    push ebx
    push ecx
    push edx
    
    ; Check real-time queue first
    mov ecx, SCHED_PRIORITY_RT
    call get_next_task_from_queue
    test eax, eax
    jnz .task_found
    
    ; Check high priority queue
    mov ecx, SCHED_PRIORITY_HIGH
    call get_next_task_from_queue
    test eax, eax
    jnz .task_found
    
    ; Check normal priority queue
    mov ecx, SCHED_PRIORITY_NORMAL
    call get_next_task_from_queue
    test eax, eax
    jnz .task_found
    
    ; Check low priority queue
    mov ecx, SCHED_PRIORITY_LOW
    call get_next_task_from_queue
    test eax, eax
    jnz .task_found
    
    ; Check idle queue
    mov ecx, SCHED_PRIORITY_IDLE
    call get_next_task_from_queue
    
.task_found:
    pop edx
    pop ecx
    pop ebx
    ret
endp

; I/O aware scheduling
align 4
proc schedule_io_task
; Input: eax = task block, ebx = I/O operation type
    
    pushad
    
    ; Mark task as I/O waiting
    mov [eax + ULTRA_TASK_BLOCK.state], TASK_STATE_IO_WAIT
    inc [eax + ULTRA_TASK_BLOCK.io_wait_count]
    
    ; Boost I/O priority for interactive tasks
    cmp [eax + ULTRA_TASK_BLOCK.priority], SCHED_PRIORITY_NORMAL
    jne .no_io_boost
    
    ; Temporarily boost priority
    mov [eax + ULTRA_TASK_BLOCK.priority], SCHED_PRIORITY_HIGH
    
.no_io_boost:
    ; Remove from current run queue
    call remove_task_from_runqueue
    
    ; Add to I/O wait queue
    call add_task_to_io_waitqueue
    
    ; Trigger scheduler
    call ultra_schedule
    
    popad
    ret
endp

; I/O completion handling
align 4
proc handle_io_completion
; Input: eax = task block
    
    pushad
    
    ; Mark task as ready
    mov [eax + ULTRA_TASK_BLOCK.state], TASK_STATE_READY
    
    ; Restore original priority if it was boosted
    mov ebx, [eax + ULTRA_TASK_BLOCK.base_priority]
    mov [eax + ULTRA_TASK_BLOCK.priority], ebx
    
    ; Remove from I/O wait queue
    call remove_task_from_io_waitqueue
    
    ; Add back to appropriate run queue
    call add_task_to_runqueue
    
    ; Check if this task should preempt current task
    call check_preemption_needed
    
    popad
    ret
endp

; Load balancing across CPUs
align 4
proc balance_cpu_load
    pushad
    
    ; Check if load balancing is needed
    rdtsc
    mov ebx, [cpu_scheduler_data.last_balance]
    sub eax, ebx
    cmp eax, [load_balance_interval]
    jb .no_balance_needed
    
    ; Update last balance time
    rdtsc
    mov [cpu_scheduler_data.last_balance], eax
    
    ; Calculate load for each CPU
    call calculate_cpu_loads
    
    ; Find most loaded and least loaded CPUs
    call find_load_imbalance
    test eax, eax
    jz .no_imbalance
    
    ; Migrate tasks from overloaded to underloaded CPUs
    call migrate_tasks_for_balance
    
.no_imbalance:
.no_balance_needed:
    popad
    ret
endp

; Power-aware scheduling
align 4
proc power_aware_schedule
    pushad
    
    ; Check system power state
    call get_power_state
    cmp eax, 1                  ; Power saving mode
    jne .normal_scheduling
    
    ; Consolidate tasks to fewer CPUs
    call consolidate_tasks_for_power
    
    ; Reduce scheduling frequency
    mov eax, [current_time_slice]
    shl eax, 1                  ; Double time slice
    mov [current_time_slice], eax
    
    jmp .power_scheduling_done
    
.normal_scheduling:
    ; Normal power mode - optimize for performance
    call optimize_for_performance
    
.power_scheduling_done:
    popad
    ret
endp

; Interrupt coalescing for better performance
align 4
proc coalesce_interrupts
    pushad
    
    ; Check interrupt rate
    call get_interrupt_rate
    cmp eax, 10000              ; 10K interrupts/sec threshold
    jb .no_coalescing
    
    ; Enable interrupt coalescing
    call enable_interrupt_coalescing
    
    ; Batch interrupt processing
    call batch_interrupt_processing
    
.no_coalescing:
    popad
    ret
endp

; Performance monitoring and optimization
align 4
proc optimize_scheduler_performance
    pushad
    
    ; Analyze scheduling patterns
    call analyze_scheduling_patterns
    
    ; Adjust time quantums based on workload
    call adjust_time_quantums
    
    ; Optimize queue priorities
    call optimize_queue_priorities
    
    ; Update performance statistics
    call update_performance_stats
    
    popad
    ret
endp

; Data section
task_id_counter         dd 1
idle_task_stack         dd 0
interrupt_coalescing    dd 0
power_state             dd 0

