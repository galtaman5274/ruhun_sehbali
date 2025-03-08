l = [5,2,1,4,6,22,3]

def sort_list(l):
    pivot_index = 0
    sorted_list = []
    sorted_list.append(l[pivot_index])
    for i in range(1,len(l)-1):
        tmp_indx = pivot_index
        
        
        while l[i] > sorted_list[tmp_indx]:
              pass
        while  l[i] < sorted_list[pivot_index]:
             
             tmp_indx -= 1
             if not tmp_indx < 0 and sorted_list[tmp_indx - 1] < sorted_list[tmp_indx]:
                  sorted_list.insert(tmp_indx,l[i])
                  pivot_index += 1
                  break
             if tmp_indx < 0 :
                 sorted_list.insert(tmp_indx,l[i])
                 pivot_index += 1
                 print(pivot_index)
                 break
                
             
                  
                  
    print(sorted_list)

sort_list(l)

def sort_list(l):
    sorted_list = [l[0]]  # Initialize with the first element

    for i in range(1, len(l)):  
        value = l[i]
        j = len(sorted_list) - 1
        
        # Find the correct position to insert the element
        while j >= 0 and sorted_list[j] > value:
            j -= 1

        # Insert the element at the correct position
        sorted_list.insert(j + 1, value)
    
    print(sorted_list)

l = [5, 2, 1, 4, 6, 22, 3]
sort_list(l)


def sort_list(l):
    pivot_index = 0  # Start pivot at the first element
    sorted_list = [l[pivot_index]]  # Initialize sorted list with first element

    for i in range(1, len(l)):  
        value = l[i]
        
        if value < sorted_list[pivot_index]:  # Insert backward
            # Find correct position from pivot to the left
            j = pivot_index
            while j > 0 and sorted_list[j - 1] > value:
                j -= 1
            
            sorted_list.insert(j, value)
            pivot_index += 1  # Increment pivot when inserting backward
        
        else:  # Insert forward
            # Find correct position from pivot to the right
            j = pivot_index
            while j < len(sorted_list) and sorted_list[j] < value:
                j += 1

            sorted_list.insert(j, value)
        
    print(sorted_list)

l = [5, 2, 1, 4, 6, 22, 3]
sort_list(l)


def cocktail_shaker_sort(arr):
    n = len(arr)
    swapped = True
    start = 0
    end = n - 1
    
    while swapped:
        swapped = False
        
        # Forward pass (left to right)
        for i in range(start, end):
            if arr[i] > arr[i + 1]:
                arr[i], arr[i + 1] = arr[i + 1], arr[i]
                swapped = True
        
        if not swapped:
            break
        
        swapped = False
        end -= 1  # Reduce range
        
        # Backward pass (right to left)
        for i in range(end - 1, start - 1, -1):
            if arr[i] > arr[i + 1]:
                arr[i], arr[i + 1] = arr[i + 1], arr[i]
                swapped = True
        
        start += 1  # Reduce range

arr = [5, 2, 1, 4, 6, 22, 3]
cocktail_shaker_sort(arr)
print(arr)


import bisect

def optimized_sort_list(l):
    sorted_list = [l[0]]  # Start with the first element
    pivot_index = 0  

    for i in range(1, len(l)):  
        value = l[i]
        
        if value < sorted_list[pivot_index]:  # Insert backward
            j = bisect.bisect_left(sorted_list, value, 0, pivot_index)  
            sorted_list.insert(j, value)  
            pivot_index += 1  # Increment pivot only when moving backward

        else:  # Insert forward
            j = bisect.bisect_right(sorted_list, value, pivot_index)  
            sorted_list.insert(j, value)  

    return sorted_list

l = [5, 2, 1, 4, 6, 22, 3]
print(optimized_sort_list(l))

def in_place_sort_list(l):
    pivot_index = 0  

    for i in range(1, len(l)):  
        value = l[i]

        if value < l[pivot_index]:  # Move backward
            j = pivot_index
            while j > 0 and l[j - 1] > value:
                j -= 1
            l.insert(j, l.pop(i))  # Moves element in-place
            pivot_index += 1  # Pivot only moves when inserting backward

        else:  # Move forward
            j = pivot_index
            while j < i and l[j] < value:
                j += 1
            l.insert(j, l.pop(i))  # Moves element in-place

    return l

l = [5, 2, 1, 4, 6, 22, 3]
print(in_place_sort_list(l))

def hybrid_sort(l):
    if len(l) <= 32:  
        return in_place_sort_list(l)  # Use optimized insertion-based sort for small arrays
    
    mid = len(l) // 2
    left = hybrid_sort(l[:mid])
    right = hybrid_sort(l[mid:])
    
    return merge(left, right)  # Merge both halves efficiently

def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] < right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result

l = [5, 2, 1, 4, 6, 22, 3]
print(hybrid_sort(l))

import bisect

def sort_list(l):
    pivot_index = 0  # Start pivot at first element
    sorted_list = [l[pivot_index]]  # Initialize sorted list

    for i in range(1, len(l)):
        value = l[i]
        
        if value < sorted_list[pivot_index]:  # Insert backward
            pos = bisect.bisect_left(sorted_list, value, 0, pivot_index)  # O(log n)
            sorted_list.insert(pos, value)  # O(n) worst-case shift
            pivot_index += 1  # Increment pivot only for backward
        
        else:  # Insert forward
            pos = bisect.bisect_right(sorted_list, value, pivot_index, len(sorted_list))  # O(log n)
            sorted_list.insert(pos, value)  # O(n) worst-case shift

    print(sorted_list)

l = [5, 2, 1, 4, 6, 22, 3]
sort_list(l)
