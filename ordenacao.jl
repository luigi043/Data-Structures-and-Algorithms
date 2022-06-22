"""
ordenacao.jl
José Jasnau Caeiro
2022-06-16

algoritmos de ordenação e
complexidade computacional
"""

"""
    insertion_sort( A )

ordenação da tabela A pelo algoritmo
insertion sort
"""

module Ordenacao

"""
    insertion_sort!( A::Array{Int16} )
algoritmo de ordenação insertion sort
"""
function insertion_sort!( A::Array{Int16} )
    for j = 2:length(A)
        key = A[ j ]
        i = j - 1
        while i > 0 && A[ i ] > key
            A[ i + 1 ] = A[ i ]
            i = i - 1
        end
        A[ i + 1 ] = key
    end
end

"""
    bubble_sort!( A )
ordenação da tabela A pelo algoritmo bubble sort
"""
function bubble_sort!( A::Array{Int16} )
    for i = 1:length( A ) - 1
        for j = length( A ):-1:i+1
            if A[ j ] < A[ j - 1 ]
                A[ j ], A[ j - 1 ] = A[ j - 1 ], A[ j ]
            end
        end
    end
end


"""
    merge!( A )
chamada para a ordenação da tabela A pelo algoritmo merge sort
"""
function merge!( A::Array{Int16}, p, q, r )
    n₁= q - p + 1
    n₂= r - q
    L = Array{Int16}(undef, n₁+1)
    R = Array{Int16}(undef, n₂+1)
    for i = 1:n₁
        L[ i ] = A[ p + i - 1 ]
    end
    for j = 1:n₂
        R[ j ] = A[ q + j ]
    end
    L[ n₁ + 1 ] = typemax(Int16)
    R[ n₂ + 1 ] = typemax(Int16)
    i = 1
    j = 1
    for k = p:r
        if L[ i ] <= R[ j ]
            A[ k ] = L[ i ]
            i = i + 1
        else
            A[ k ] = R[ j ]
            j = j + 1
        end
    end
end

"""
    merge_sort!( A )
ordenação da tabela A pelo algoritmo merge sort
"""
function merge_sort!( A::Array{Int16}, p, r )
    if p < r
        q = convert(Int64,
                    floor( (convert(Float64, p) +
                        convert(Float64, r)) / 2.0 ))
        merge_sort!( A, p, q )
        merge_sort!( A, q+1, r )
        merge!( A, p, q, r )
    end
end

"""
    left( i )
parte da ordenação pelo algoritmo heap sort
"""
function left( i )
    2 * i
end

"""
    right( i )
parte da ordenação pelo algoritmo heap sort
"""
function right( i )
    2 * i + 1
end

mutable struct HeapArray
    A::Array{Int64}
    heap_size
    HeapArray( A, n ) = new(A, n)
end

"""
    max_heapify!( A::Array{Int16}, i )
parte da ordenação pelo algoritmo
heap sort
"""
function max_heapify!( H::HeapArray, i )
    l = left( i )
    r = right( i )
    if l <= H.heap_size && H.A[ l ] > H.A[ i ]
        largest = l
    else
        largest = i
    end
    if r <= H.heap_size && H.A[ r ] > H.A[ largest ]
        largest = r
    end
    if largest != i
        H.A[ i ], H.A[ largest ] = H.A[ largest ], H.A[ i ]
        max_heapify!( H, largest )
    end
end

"""
    build_max_heap!( H )
parte da ordenação pelo algoritmo heap sort
"""
function build_max_heap!( H::HeapArray )
    H.heap_size = length( H.A )
    N = convert(Int64, floor(convert(Float64, length( H.A )) / 2.0))
    for i = N:-1:1
        max_heapify!(H, i)
    end
end

"""
    heap_sort!( A )
ordenação pelo algoritmo heap sort
"""
function heap_sort!( A::Array{Int16} )
    H = HeapArray(A, length( A ))
    build_max_heap!( H )
    for i = length( H.A ):-1:2
        H.A[ 1 ], H.A[ i ] = H.A[ i ], H.A[ 1 ]
        H.heap_size = H.heap_size - 1
        max_heapify!(H, 1)
    end
    A::Array{Int16} = H.A
end


"""
    partition( A, p, r )

parte da ordenação da tabela A pelo algoritmo
quick sort
"""
function partition( A::Array{Int16}, p, r )
    x = A[ r ]
    i = p - 1
    for j = p:r-1
        if A[ j ] <= x
            i = i + 1
            A[ i ], A[ j ] = A[ j ], A[ i ]
        end
    end
    A[ i + 1 ], A[ r ] = A[ r ], A[ i + 1 ]
    i + 1
end

"""
    quick_sort!( A, p, r )

ordenação da tabela A pelo algoritmo
quick sort
"""
function quick_sort!( A::Array{Int16}, p, r )
    if p < r
        q = partition( A, p, r )
        quick_sort!( A, p, q - 1 )
        quick_sort!( A, q + 1, r )
    end
end

"""
    a_sua_sina( s )
calcula a sua sina...
o argumento s não deve ter acentos nem cedilhas
"""
function a_sua_sina( s::String )
    N = 5
    soma = sum( [ Int( c ) for c in s ] ) % N
    if soma == 0
        a = "insertion"
    elseif soma == 1
        a = "bubble"
    elseif soma == 2
        a = "merge"
    elseif soma == 3
        a = "heap"
    else
        a = "quick"
    end

    try
        meia = sum( [ Int( s[ k ] ) + 1 
                      for k = 1:Int(floor(length( s ) / 2)) ] ) % N
    catch e
        println( "escreva o seu nome completo" )
        println( "SEM USAR ACENTOS NEM CEDILHAS" )
        return
    end

    meia = sum( [ Int( s[ k ] ) + 1 
                  for k = 1:Int(floor(length( s ) / 2)) ] ) % N

    meia = (meia != soma) ? meia : (( meia + 1 > N) ? 0 : meia)
    
    if meia == 0
        b = "insertion"
    elseif meia == 1
        b = "bubble"
    elseif meia == 2
        b = "merge"
    elseif meia == 3
        b = "heap"
    else
        b = "quick"
    end
    a, b 
end

end # Ordenacao
