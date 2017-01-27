data BinaryTree a =
    Leaf
  | Node (BinaryTree a) a (BinaryTree a)
  deriving (Eq, Ord, Show)

testTree :: BinaryTree Integer
testTree = Node (Node Leaf 1 Leaf) 2 (Node Leaf 3 (Node Leaf 4 Leaf))

testPreorder :: IO ()
testPreorder =
  if preorder testTree == [2, 1, 3, 4]
  then putStrLn "Preorder fine!"
  else putStrLn "Bad news bears."

testInorder :: IO ()
testInorder =
  if inorder testTree == [1, 2, 3, 4]
  then putStrLn "Inorder fine!"
  else putStrLn "Bad news bears."

testPostorder :: IO ()
testPostorder =
  if postorder testTree == [1, 4, 3, 2]
  then putStrLn "Postorder fine!"
  else putStrLn "postorder failed check"

-- Implementation

preorder :: BinaryTree a -> [a]
preorder Leaf         = []
preorder (Node l x r) = x : preorder l ++ preorder r

inorder :: BinaryTree a -> [a]
inorder Leaf         = []
inorder (Node l x r) = inorder l ++ [x] ++ inorder r

postorder :: BinaryTree a -> [a]
postorder Leaf         = []
postorder (Node l x r) = postorder l ++ postorder r ++ [x]
