#BINARY TREE
module Binary_Tree_Module

#*Node struct
mutable struct Node
    #Nome da variável::tipo
    value::Int64
    left_child::Any
    right_child::Any
    parent::Any

end
#Node Construtor
function Node(value::Int64)
    Node(value, "null", "null", "null") 
end

#*Tree struct
mutable struct Tree
    #Nome da variável::tipo
    root::Any
end

#Tree Construtor
function Tree()
    Tree("null") 
end

#ADD To Tree
function my_tree_add!(T::Tree, value::Int64)
    T.root = add_recursive!(T.root, value);
end

function add_recursive!(current::Any, value::Int64)
    if (current == "null")
        return Node(value)
    end
        
    if(value < current.value)
        left_child = add_recursive!(current.left_child, value) 
        current.left_child =  left_child

        #Set parent of root of right subtree
        left_child.parent = current

    elseif (value > current.value)
        right_child = add_recursive!(current.right_child, value) 
        current.right_child =  right_child

        #Set parent of root of right subtree
        right_child.parent = current
    end
    
    return current
end


#DELETE From Tree
function my_tree_delete!(T::Tree, value::Int64)
    T.root = delete_recursive!(T.root, value);
end

function findSmallestValue(root::Node)
    #We'll use the smallest node of the soon to be deleted node's right sub-tree
    #Se não tiver filhos a esquerda, ele é que é menor, se tiver, procurar sempre a esquerda pois queremos o menor
    return root.left_child == "null" ? root.value : findSmallestValue(root.left_child)
end

function delete_recursive!(current::Any, value::Int64)
    if(current == "null")
        return "null";
    end

    if(value == current.value)
        #Node to delete found

        #*Case 1: a node has no children 
        if(current.left_child == "null" && current.right_child == "null")
            return "null"
        end

        #*Case 2: a node has exactly one child
        if(current.right_child == "null")
            return current.left_child
        end

        if(current.left_child == "null")
            return current.right_child
        end

        #*Case 3: a node has two children
        smallest_value = findSmallestValue(current.right_child)
        current.value = smallest_value
        current.right_child = delete_recursive!(current.right_child, smallest_value)
        return current
    end

    if(value < current.value)
        current.left_child = delete_recursive!(current.left_child, value)
        return current
    end

    #Value é maior que current.value
    #current.right_child = delete_recursive!(current.right_child, value)
    return current
end

function inorder_tree_walk!(x::Any)
    if x != "null"
        inorder_tree_walk!(x.left_child)
        print(x.value," ")
        inorder_tree_walk!(x.right_child)
    end
end

function tree_search!(x::Any, k::Int64)
    if x == "null" || k == x.value
        return x
    end

    if k < x.value
        return tree_search!(x.left_child, k)
    else
        return tree_search!(x.right_child, k)
    end

end

function iterative_tree_search!(x::Any, k::Int64)
    while x != "null" && k != x.value
        if k < x.value
            x = x.left_child
        else
            x = x.right_child
        end
    end 
    return x 
end

function tree_minimum!(x)
    while x.left_child != "null"
        x = x.left_child
    end
    return x
end

function tree_maximum!(x)
    while x.right_child != "null"
        x = x.right_child
    end
    return x
end

function tree_successor!(x::Any)
    if x.right_child != "null"
        return tree_minimum!(x)
    end

    y = x.parent

    while y != "null" && x == y.right_child
        x = y 
        y = y.parent
    end

    return y

end

function tree_insert!(T::Tree, z::Any)
    y = "null"
    x = T.root

    #procurar o node a colocar valor 
    while x != -"null"
        y = x
        if z.value < x.value
            x = x.left_child
        else
            x = x.right_child
        end
    end
    z.parent = y

    #Colocar o valor no node y
    if y == "null"
        T.root = z #Tree was empty
    elseif z.value < y.value
        y.left_child = z
    else
        y.right_child = z
    end
end

function transplant!(T::Tree, u::Any, v::Any)
    if u.parent == "null"
        T.root = v
    elseif u == u.parent.left_child
        u.parent.left_child = v
    else
        u.parent.right_child = v
    end

    if v != "null"
        v.parent = u.parent
    end
end

function tree_delete!(T::Tree, z::Any)
    if z.left_child == "null"
        transplant!(T, z, z.right_child)
    elseif z.right_child == "null"
        transplant!(T, z, z.left_child)
    else
        y = tree_minimum!(z.right_child)
        if y.parent != z
            transplant!(T, y, y.right_child)
            y.right_child = z.right_child
            y.right_child.parent = y
        end
        transplant!(T, z, y)
        y.left_child = z.left_child
        y.left_child.parent = y
    end

end
function binary_tree()
    #Tree
    T = Tree() 

    #Adicao
    my_tree_add!(T, 8)
    my_tree_add!(T, 15)
    my_tree_add!(T, 7)
    println(T)

    #Delete
    #my_tree_delete!(T, 8)
    #println(T)

    #Inorder tree walk
    #inorder_tree_walk!(T.root)

    #Tree Search
    #searched_node = tree_search!(T.root, 15)
    #println(searched_node)

    #Iterative tree search
    #iter_searched_node = iterative_tree_search!(T.root, 15)
    #println(iter_searched_node)

    #Tree minimum and minimum
    # minimum_tree = tree_minimum!(T.root)
    # maximum_tree = tree_maximum!(T.root)
    # println("Minumum: ",minimum_tree)
    # println("Maximum: ",maximum_tree)

    #Tree successor and predecessor
    # successor = tree_successor!(T.root.left_child)
    # println("Successor: ",successor)
end

#-------------------
function main()

    #Binary Tree
    binary_tree()
    
end

#CALL MAIN
main()

end