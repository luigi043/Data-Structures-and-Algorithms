"""
arvores.jl
José Jasnau Caeiro
2022-06-16

representação e gestão de memória de árvores
"""


module Arvores

using Printf

include("simples.jl")

const RED   = 0
const BLACK = 1


"""
    MemoryBinaryTreeRB
a estrutura de dados permite a representação
de listas duplamente ligadas com até n entradas
"""
mutable struct MemoryBinaryTreeRB
    key::Array{Int16}
    p::Array{Int16}
    left::Array{Int16}
    right::Array{Int16}
    color::Array{Int}
    free::Simples.Stack
end


"""
    MemoryBinaryTreeRB( n )
construtor de memória para n posições
realização com sentinela
"""
function MemoryBinaryTreeRB( n )
    S = Simples.Stack( n )
    for x::Int16 = 2:n
        Simples.push!(S, x)
    end
    MemoryBinaryTreeRB( ones(Int16,  n ),
                        ones(Int16,  n ),
                        ones(Int16,  n ),
                        ones(Int16,  n ),
                        ones(Int,    n ),                            
                        S,
                        1 )
end


"""
    allocate_object!( mem )

reserva memória para um objeto da árvore binária
"""
function allocate_object!( mem::MemoryBinaryTreeRB )
    Simples.pop!( mem.free )
end

"""
    free_object!( mem, x )

liberta memória para um objeto da árvore binária
"""
function free_object!( mem::MemoryBinaryTreeRB, x )
    Simples.push!( mem.free, x )
end

# posição 1 da memória é uma sentinela
const NIL = 1


"""
    BinaryTreeRB

representação de árvore de pesquisa binária
"""
mutable struct BinaryTreeRB
    mem::MemoryBinaryTreeRB
    root

    BinaryTreeRB( mem::MemoryBinaryTreeRB ) = new( mem, NIL )
end

"""
    imprimirRB( T, x )
imprime na consola o registo de memória associada à posição x
"""
function imprimirRB(T, x)
    key = T.mem.key[ x ]

    if T.mem.p[ x ] != NIL
        p = T.mem.key[T.mem.p[ x ]]
    else
        p = NIL
    end
    
    if T.mem.left[ x ] != NIL
        left = T.mem.key[T.mem.left[ x ]]
    else
        left = NIL
    end
    
    if T.mem.right[ x ] != NIL
        right = T.mem.key[T.mem.right[ x ]]
    else
        right = NIL
    end

    color = T.mem.color[ x ] == RED ? "RED" : "BLACK"

    # println( "key = $key, p = $p, left = $left, right = $right, color = $color" )
    @printf( "pos => %3d | key = %3d | p => %3d | left => %3d | right => %3d | color = %s\n",
            x, key, p, left, right, color)
end

"""
    inorder_tree_walk( T, x )
percorre a árvore T a partir do nó x
"""
function inorder_tree_walk( T, x )
    if x != NIL
        inorder_tree_walk(T, T.mem.left[ x ])
        imprimirRB(T, x)
        inorder_tree_walk(T, T.mem.right[ x ])
    end        
end

"""
    left_rotate!( T, x )
rotação à esquerda
"""
function left_rotate!( T, x )
    y = T.mem.right[ x ]
    T.mem.right[ x ] = T.mem.left[ y ]
    if T.mem.left[ y ] != NIL
        T.mem.p[ T.mem.left[ y ]] = x
    end
    T.mem.p[ y ] = T.mem.p[ x ]
    if T.mem.p[ x ] == NIL
        T.root = NIL
    else
        if x == T.mem.left[ T.mem.p[ x ]]
            T.mem.left[ T.mem.p[ x ]] = y
        else
            T.mem.right[ T.mem.p[ x ]] = y
        end
    end
    T.mem.left[ y ] = x
    T.mem.p[ x ] = y
end

"""
    right_rotate!( T, x )
rotação à esquerda
"""
function right_rotate!( T, x )
    y = T.mem.left[ x ]
    T.mem.left[ x ] = T.mem.right[ y ]
    if T.mem.right[ y ] != NIL
        T.mem.p[ T.mem.right[ y ]] = x
    end
    T.mem.p[ y ] = T.mem.p[ x ]
    if T.mem.p[ x ] == NIL
        T.root = NIL
    else
        if x == T.mem.right[ T.mem.p[ x ]]
            T.mem.right[ T.mem.p[ x ]] = y
        else
            T.mem.left[ T.mem.p[ x ]] = y
        end
    end
    T.mem.right[ y ] = x
    T.mem.p[ x ] = y
end


"""
    RB_insert_fixup!(T, z)
corrigir a árvore RB
"""
function RB_insert_fixup!(T, z)
    while ( T.mem.color[ T.mem.p[ z ]] == RED ) 
        if T.mem.p[ z ] == T.mem.left[ T.mem.p[ T.mem.p[ z ]]]
            y = T.mem.right[ T.mem.p[ T.mem.p[ z ]]]
            if T.mem.color[ y ] == RED
                T.mem.color[ T.mem.p[ z ]] = BLACK
                T.mem.color[ y ] = BLACK
                T.mem.color[ T.mem.p[ T.mem.p[ z ]]] = RED
                z = T.mem.p[ T.mem.p[ z ]]
            else
                if z == T.mem.right[ T.mem.p[ z ]]
                    z = T.mem.p[ z ]
                    left_rotate!( T, z )
                end
                T.mem.color[ T.mem.p[ z ]] = BLACK
                T.mem.color[ T.mem.p[ T.mem.p[ z ]]] = RED
                right_rotate!( T, T.mem.p[ T.mem.p[ z ]] )
            end
        else
            y = T.mem.left[ T.mem.p[ T.mem.p[ z ]]]
            if T.mem.color[ y ] == RED
                T.mem.color[ T.mem.p[ z ]] = BLACK
                T.mem.color[ y ] = BLACK
                T.mem.color[ T.mem.p[ T.mem.p[ z ]]] = RED
                z = T.mem.p[ T.mem.p[ z ]]
            else
                if z == T.mem.left[ T.mem.p[ z ]]
                    z = T.mem.p[ z ]
                    right_rotate!( T, z )
                end
                T.mem.color[ T.mem.p[ z ]] = BLACK
                T.mem.color[ T.mem.p[ T.mem.p[ z ]]] = RED
                left_rotate!( T, T.mem.p[ T.mem.p[ z ]] )
            end
        end
    end
    T.mem.color[ T.root ] = BLACK
end


"""
    RB_insert!(T, key)
inserção de elemento na árvore de pesquisa binária RB
"""
function RB_insert!( T, key )
    z = allocate_object!( T.mem )
    T.mem.key[ z ] = key

    y = NIL
    x = T.root
    while x != NIL
        y = x
        if T.mem.key[ z ] < T.mem.key[ x ]
            x = T.mem.left[ x ]
        else
            x = T.mem.right[ x ]
        end
    end
    
    T.mem.p[ z ] = y
    if y == NIL
        T.root = z
    else
        if T.mem.key[ z ] < T.mem.key[ y ]
            T.mem.left[ y ] = z
        else
            T.mem.right[ y ] = z
        end
    end
    T.mem.left[ z ] = NIL
    T.mem.right[ z ] = NIL
    T.mem.color[ z ] = RED
    RB_insert_fixup!( T, z )
end

"""
    tree_minimum( T, x )
devolve o nó com a chave mínima
"""
function tree_minimum( T, x )
    while T.mem.left[ x ] != NIL
        x = T.mem.left[ x ]
    end
    imprimirRB(T, x)
    x
end

"""
     RB_transplant!( T, u, v )
operação de transplante usada em RB_delete
"""
function RB_transplant!( T, u, v )
    if T.mem.p[ u ] == NIL
        T.root = v
    else
        if u == T.mem.left[ T.mem.p[ u ]]
            T.mem.left[ T.mem.p[ u ]] = v
        else
            T.mem.right[ T.mem.p[ u ]] = v
        end
    end
    T.mem.p[ v ] = T.mem.p[ u ]
end

"""
    RB_delete_fixup( T, x )
corrige as cores RB da árvore após remoção dum nó
"""
function RB_delete_fixup( T, x )
    while x != T.root && T.mem.color[ x ] == BLACK
        if x == T.mem.left[ T.mem.p[ x ]]
            w = T.mem.right[ T.mem.p[ x ]]
            if T.mem.color[ w ] == RED
                T.mem.color[ w ] = BLACK
                T.mem.color[ T.mem.p[ w ]] = RED
                left_rotate( T, T.mem.p[ x ] )
                w = T.mem.right[ T.mem.p[ x ]]
            end
            if T.mem.color[ T.mem.left[ w ]] == BLACK && T.mem.color[ T.mem.right[ w ]] == BLACK
                T.mem.color[ w ] = RED
                x = T.mem.p[ x ]
            else
                if T.mem.color[ T.mem.right[ w ]] == BLACK
                    T.mem.color[ T.mem.left[ w ]] = BLACK
                    T.mem.color[ w ] = RED
                    right_rotate( T, w )
                    w = T.mem.right[ T.mem.p[ x ]]
                end
                T.mem.color[ w ] = T.mem.color[ T.mem.p[ x ]]
                T.mem.color[ T.mem.p[ x ]] = BLACK
                T.mem.color[ T.mem.right[ w ]] = BLACK
                left_rotate( T, T.mem.p[ x ] )
                x = T.root
            end
        else
            w = T.mem.left[ T.mem.p[ x ]]
            if T.mem.color[ w ] == RED
                T.mem.color[ w ] = BLACK
                T.mem.color[ T.mem.p[ w ]] = RED
                right_rotate( T, T.mem.p[ x ] )
                w = T.mem.left[ T.mem.p[ x ]]
            end
            if T.mem.color[ T.mem.right[ w ]] == BLACK && T.mem.color[ T.mem.left[ w ]] == BLACK
                T.mem.color[ w ] = RED
                x = T.mem.p[ x ]
            else
                if T.mem.color[ T.mem.left[ w ]] == BLACK
                    T.mem.color[ T.mem.right[ w ]] = BLACK
                    T.mem.color[ w ] = RED
                    left_rotate( T, w )
                    w = T.mem.left[ T.mem.p[ x ]]
                end
                T.mem.color[ w ] = T.mem.color[ T.mem.p[ x ]]
                T.mem.color[ T.mem.p[ x ]] = BLACK
                T.mem.color[ T.mem.left[ w ]] = BLACK
                right_rotate( T, T.mem.p[ x ] )
                x = T.root
            end
        end
    end
    T.mem.color[ x ] = BLACK
end

"""
    RB_delete( T, z )
remoção do nó z
"""
function RB_delete( T, z )
    y = z  
    y_original_color = T.mem.color[ y ]
    if T.mem.left[ z ] == NIL
        x = T.mem.right[ z ]
        RB_transplant!( T, z, T.mem.right[ z ] )
    else
        if T.mem.right[ z ] == NIL
            x = T.mem.left[ z ]
            RB_transplant!( T, z, T.mem.left[ z ] )
        else
            y = tree_minimum( T, T.mem.right[ z ] )
            y_original_color = T.mem.color[ y ]
            x = T.mem.right[ y ]
            if T.mem.p[ y ] == z
                T.mem.p[ x ] = y
            else
                RB_transplant!( T, y, T.mem.right[ y ] )
                T.mem.right[ y ] = T.mem.right[ z ]
                T.mem.p[ T.mem.right[ y ]] = y
            end
            RB_transplant!( T, z, y )
            T.mem.left[ y ] = T.mem.left[ z ]
            T.mem.p[ T.mem.left[ y ]] = y
            T.mem.color[ y ] = T.mem.color[ z ]
        end
    end
    if y_original_color == BLACK
        RB_delete_fixup( T, x )
    end
    free_object!( T.mem, z )
end

"""
    recursive_tree_search( T, x, k )
pesquisa numa árvore 
"""
function recursive_tree_search( T, x, k )
    if x == NIL || k == T.mem.key[ x ]
        return x
    end
    if k < T.mem.key[ x ]
        return recursive_tree_search( T, T.mem.left[ x ], k )
    else
        return recursive_tree_search( T, T.mem.right[ x ], k )
    end
end

end # module
