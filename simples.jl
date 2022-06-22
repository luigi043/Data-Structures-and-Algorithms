"""
simples.jl
José Jasnau Caeiro
2022-06-16

algoritmos usados em EDA
estruturas de dados simples

"""

module Simples

"""
    Stack

representação duma pilha com n elementos
"""
mutable struct Stack
    S::Array{Int16}
    top
    Stack(n) = new(Array{Int16}(undef, n), 0)
end

"""
    stack_empty(S)
determina se a pilha se encontra vazia
"""
function stack_empty( S::Stack )
    if S.top == 0
        return true
    else
        return false
    end
end

"""
    push!(S, x)
empurra um elemento para a pilha
"""
function push!( S::Stack, x::Int16 )
    S.top = S.top + 1
    S.S[ S.top ] = x
end

"""
    pop!(S, x)
saca um elemento da pilha
"""
function pop!( S::Stack )
    if stack_empty( S )
        println("error underflow")
        return
    else
        S.top = S.top - 1
        return S.S[ S.top + 1 ]
    end
end

mutable struct Queue
    Q::Array{Int16}
    head
    tail

    Queue(n) = new(Array{Int16}(undef, n), 1, 1)
end

"""
    enqueue!( Q::Queue, x::Int16 )
coloca na fila de espera o elemento x
"""
function enqueue!( Q::Queue, x::Int16 )
    Q.Q[ Q.tail ] = x
    if Q.tail == length( Q.Q )
        Q.tail = 1
    else
        Q.tail = Q.tail + 1
    end
end

"""
    dequeue!( Q::Queue )
busca da fila de espera o primeiro elemento
"""
function dequeue!( Q::Queue )
    x = Q.Q[ Q.head ]
    if Q.head == length( Q.Q )
        Q.head = 1
    else
        Q.head = Q.head + 1
    end
    x
end

"""
    MemoryDoubleLinkedList
a estrutura de dados permite a representação
de listas duplamente ligadas com até n entradas
"""
mutable struct MemoryDoubleLinkedList
    key::Array{Int16}
    prev::Array{Int16}
    next::Array{Int16}
    free::Stack
    NIL
end

"""
    MemoryDoubleLinkedList( n )
construtor de memória para n posições
"""
function MemoryDoubleLinkedList( n )
    S = Stack( n )
    for x::Int16 = 1:n
        push!(S, x)
    end
    MemoryDoubleLinkedList( zeros(Int16,  n ),
                            zeros(Int16,  n ),
                            zeros(Int16,  n ),
                            S,
                            1 )

end

"""
    allocate_object!( mem )

reserva memória para um objeto da lista duplamente ligada
"""
function allocate_object!( mem::MemoryDoubleLinkedList )
    pop!( mem.free )
end

"""
    free_object!( mem )

liberta memória para um objeto da lista duplamente ligada
"""
function free_object!( mem::MemoryDoubleLinkedList, x )
    push!( mem.free, x )
end

const NIL = 0

"""
    DoubleLinkedList

representação de lista duplamente ligada
"""
mutable struct DoubleLinkedList
    mem::MemoryDoubleLinkedList
    head

    DoubleLinkedList( mem::MemoryDoubleLinkedList ) = new( mem, NIL )
end

"""
    list_insert!( l::DoubleLinkedList, key )
inserção dum elemento da lista com o valor key
"""
function list_insert!( l::DoubleLinkedList, key )
    x = allocate_object!( l.mem )
    l.mem.key[ x ] = key
    
    l.mem.next[ x ] = l.head
    if l.head != NIL
        l.mem.prev[ l.head ] = x
    end
    l.head = x
    l.mem.prev[ x ] = NIL
end

"""
    list_delete!( l, x )
remove um elemento da lista na posição x da memória
"""
function list_delete!( l, x )
    if l.mem.prev[ x ] != NIL
       l.mem.next[ l.mem.prev[ x ]] = l.mem.next[ x ] 
    else
        l.head = l.mem.next[ x ]
    end
    if l.mem.next[ x ] != NIL
        l.mem.prev[ l.mem.next[ x ]] = l.mem.prev[ x ]
    end
    free_object!( l.mem, x )
end

"""
    list_search( l, key )
pesquisa do elemento da lista l com a chave key
"""
function list_search( l, key )
    x = l.head
    while x != NIL && l.mem.key[ x ] != key
        x = l.mem.next[ x ]
    end
    x
end

end # module Simples
