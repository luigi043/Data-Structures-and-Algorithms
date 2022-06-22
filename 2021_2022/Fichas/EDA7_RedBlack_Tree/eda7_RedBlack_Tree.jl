module red_black_tree


#*------------STACK AND FUNCTIONS---------------------
#*....Stack "Class"
mutable struct MyStack
    #Nome da variável::tipo
    top::Int64
    content::Vector{Int64}
end
#Construtor
function MyStack(n::Int64)
    content = zeros(Int64, n) #Tipo inteiro com 'n' de espaco
    MyStack(0, content) #Top sempre inicializa a zero
end
#Push
function my_push!(S::MyStack, x::Int64)
    if(S.top == length(S.content))
        println("Overflow!")
    else
        S.top = S.top + 1 #Esta ordem de adic index e depois colocar , faz com que pos comece sempre no 1 e deve ser assim por causa do Julia
        S.content[S.top] = x
    end
    
end 

#*------
#Stack Empty
function my_stack_empty!(S)
    if(S.top == 0)
        return true
    else
        return false
    end
end

#Pop
function my_pop!(S)
    if my_stack_empty!(S)
        println("Underflow!")
    else
        S.top = S.top - 1 #Podemos não tirar já que no proximo push vamos sobrepor o numero
        return S[S.top + 1]
    end
end

#*Node struct
mutable struct Node
    #Nome da variável::tipo
    value::Int64
    left_child::Any
    right_child::Any
    parent::Any
    color::Any
    

end
#Node Construtor
function Node(value::Int64)
    Node(value, "null", "null", "null", "Red") 
end

mutable struct MemoriaArvore
    S::MyStack
    key::Vector{Int64}
    left::Vector{Int64}
    right::Vector{Int64}
    parent::Vector{Int64}
    color::Vector{Int64}
    #MemoriaArvore(n) = new( MyStack(n), zeros(Int64, n), zeros(Int64, n), zeros(Int64, n), zeros(Int64, n), zeros(Int64, n))
end

function MemoriaArvore(n)
    m = new( MyStack(n), zeros(Int64, n), zeros(Int64, n), zeros(Int64, n), zeros(Int64, n), zeros(Int64, n))
    for k = 1:n
        m.S.content.my_push!(k)
    end

end

#*Tree struct
mutable struct Tree
    #Nome da variável::tipo
    root::Any
    nil::Any
end

#Tree Construtor
function Tree()
    Tree(Node(0, "null", "null", "null", "Black"), Node(0, "null", "null", "null", "Black")) 
    #Tree("null", "null") 
end

function left_rotate!(T::Tree, x::Any)
    y = x.right_child #Set y
    x.right_child = y.left_child #Turn y's left subtree into x's right subtree

    if y.left_child != T.nil
        y.left_child.parent = x
    end

    y.parent = x.parent #Link x's parent to y

    if x.parent == T.nil
        T.root = y
    elseif x == x.parent.left_child
        x.parent.left_child = y
    else
        x.parent.right_child = y
    end

    y.left_child = x #Put x on y's left
    x.parent = y
end

function right_rotate!(T::Tree, x::Any)
    y = x.left_child #Set y
    x.left_child = y.right_child #Turn y's right subtree into x's left subtree

    if y.right_child != T.nil
        y.right_child.parent = x
    end

    y.parent = x.parent #Link x's parent to y

    if x.parent == T.nil
        T.root = y
    elseif x == x.parent.right_child
        x.parent.right_child = y
    else
        x.parent.left_child = y
    end

    y.right_child = x #Put x on y's right
    x.parent = y
end



function rb_insert(T::Tree, z::Any)
   y = T.nil
   x  = T.root
   

   while x != T.nil
        y = x
        if z.value < x.value
            x = x.left_child
        else
            x = x.right_child
        end
   end

   z.parent = y

   if y == T.nil
        T.root = z
   elseif z.value < x.value
        y.left_child = z
   else
        y.right_child  = z
   end

   z.left_child = T.nil
   z.right_child = T.nil

   #!MEU CODIGO
   if(z.parent == "null")
        z.color = "Black"
        return
   end

   if(z.parent.parent == "null")
        return
   end
   
   #z.color = "Red"
   rb_insert_fixup(T, z)
end

function rb_insert_fixup(T::Tree, z::Any)

    while z.parent.color == "Red"
        if z.parent == z.parent.parent.left_child
            y = z.parent.parent.right_child

            if y.color == "Red"
                z.parent.color = "Black"
                y.color = "Black"
                z = z.parent.parent
            elseif z == z.parent.right
                z = z.parent
                left_rotate!(T, z)
            end

            z.parent.color = "Black"
            z.parent.parent.color = "Red"
            right_rotate!(T, z)
        else
            y = z.parent.parent.right_child

            if y.color == "Red"
                z.parent.color = "Black"
                y.color = "Black"
                z = z.parent.parent
            elseif z == z.parent.right
                z = z.parent
                right_rotate!(T, z)
            end

            z.parent.color = "Black"
            z.parent.parent.color = "Red"
            left_rotate!(T, z)
        end
    end
end

function main()
#=     T = Tree()
    rb_insert(T, Node(10))
    println(T.root) =#

    m = MemoriaArvore(20)
    println(m)
end

main()

end