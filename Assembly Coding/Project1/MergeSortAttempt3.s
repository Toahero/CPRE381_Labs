    .data
array:  .word  12, 11, 13, 5, 6, 7  # Example array
n:      .word  6                    # Array length

    .text
    .globl _start
_start:
    # Load array and length
    la      t0, array          # Load base address of array into t0
    lw      t1, n              # Load length of the array into t1 (n)
    addi    t2, t1, -1         # t2 = n - 1 (end index of array)

    # Call merge sort: merge_sort(t0, 0, t2)
    jal     ra, merge_sort

    # Exit the program (via ecall)
    li      a7, 10             # Exit syscall
    ecall

# Merge Sort Function (merge_sort(arr, left, right))
merge_sort:
    # Arguments:
    # t0 - base address of the array
    # t1 - left index
    # t2 - right index
    # We use registers t3, t4, t5 for temporary calculations
    # Base case: if left >= right, return
    bge     t1, t2, merge_sort_return

    # Calculate mid = (left + right) / 2
    add     t3, t1, t2          # t3 = left + right
    srai    t3, t3, 1           # t3 = (left + right) / 2

    # Recursive call: merge_sort(arr, left, mid)
    jal     ra, merge_sort

    # Recursive call: merge_sort(arr, mid+1, right)
    addi    t4, t3, 1           # t4 = mid + 1
    mv      t5, t2              # t5 = right
    jal     ra, merge_sort

    # Merge the two halves: merge(arr, left, mid, right)
    mv      t1, a0              # Left index
    mv      t2, a1              # Right index
    mv      t3, a2              # Mid index
    jal     ra, merge

merge_sort_return:
    ret

# Merge Function (merge(arr, left, mid, right))
merge:
    # Arguments:
    # t0 - base address of the array
    # t1 - left index
    # t2 - right index
    # t3 - mid index
    # Temporary registers t4, t5 for merging
    mv      t4, t1              # t4 = left
    mv      t5, t2              # t5 = right

    # Allocate temporary array for merged result
    # This assumes space for the temporary array is available.
    # In a real-world example, you'd need to either use a separate memory space or handle this differently.
    # For simplicity, we skip temporary memory management here.

    # Merge logic (simplified version of merge)
    loop_merge:
        bge     t4, t3, finish_merge    # If left index > mid, we are done
        bge     t5, t2, finish_merge    # If right index > right, we are done

        lw      t6, 0(t0)      # Load left element
        lw      t7, 4(t0)      # Load right element

        # Merge logic would go here (comparing and storing in temporary array)

finish_merge:
    ret