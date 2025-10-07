- What do I mean by that? I mean being able to take objects in a measurable space and determine if they intersect each other

**GO TO FIRST IMAGE**
- This is a very important field of study for game engines the world over, as every physics frame, they need to check if an object has collided with every other object in the level

- A quick reminder of how this search would look at it's most basic using Big O notation, we are looking at an exponentially increasing number of connections, O(n^2)

***COLLISION MASKING***
- A lot of study has gone into how to improve this, such as collision masking, which allows objects to only collide with certain types of objects
	- This allows us to manually reduce our overhead by separating objects into different collision layers, and can lead to very large improvements
	- In our example, we've made our angry sun and bird only collide with the player, and our platforms only able to collide with our moving, grounded entities

***COMPARING GEOMETRIC SHAPES***
- Another issue we have is the actual collision detection, here we have our angry sun and legally distinct walking mushroom, the sun has 16 outwards facing lines, while our mushroom only has 6
	- Circles are the easiest shape to detect collisions on, but that is unimportant right now
- To check for collision, we have to check if any of the lines of our sun collide with our mushroom, which is 96 different checks, or O(n\*m) in Big(O)
- If every of our 14 objects had 16 lines, we would be looking at 23,296 line collision checks, which is what we in the industry call "terrible scaling"

***INTRODUCING AXIS-ALIGNED BOUNDING BOXES***
- An innovation for improving this was using axis-aligned bounding boxes, or AABBs for short
	- These are just boxes around all our objects that are all straight lines parallel to an axis, in this case, the x and y coordinates
	- The idea is that 99% of the time, an object is not going to be colliding with another object, so we should do a very quick, inexpensive check to see if they could feasibly collide, and then only do the expensive geometric comparison afterwards
		- This check is a wonderful O(1), as it is at most 4 number comparisons with and statements, which allow us to very quickly determine if objects could conceivably collide
	- Here, we've moved our bird into our angry sun, they aren't colliding, but their AABBs are, so in this example, we are doing 91 very quick O(1) checks and then one O(n\*m) check, ignoring our 5 grounded entities, which would be checking their collision with the ground below them

***REFERENCING DUNE***
- This is all well and good, but still a little too specific and in the weeds about optimisation. Let's approach this with a more abstract representation. Good thing I've got one ready to go, let's look at these stills from the hit new sci-fi movie, Dune.
- Here we can see Gurney Halleck is a pretty complex shape to check collision against, but once we wrap him in a Holtzman shield, we are dealing now with incredibly simple geometric shapes.

- Going back to our original intent, our issues were the amount of checks we were doing and the complexity of those checks. We've tackled both these problems and brought our processing down from 10s of 1000s of checks to probably less than 1000. That's about all we can do, really.

***INTRODUCING AXIS-ALIGNED BOUNDING BOX TREES***
- Obviously, given the length of this talk and the stated title, we're can go even further beyond. Let's introduce our next innovation, the Axis-Aligned Bounding Box Tree, or AABB Tree for short
	- As a disclaimer, I made the tree by eye and not with mathematical principles, so I can't promise it is the most well distributed tree
- Here we can see that we've taken all our AABBs and arranged them into a binary tree, which allows us to do a binary tree search of collision, hell yeah!
- To see why we've done this and what benefit it gives, let's take a new object, let's say this little ghost guy that we can call a Scare, and check it's collisions
	- So we are definitely colliding with A's bounding box
	- Not the bird, but we are colliding with B
	- Not C, but definitely I.
	- And neither the platform nor the J box.
- And done, we know this Scare doesn't collide with anything, and we figured it out in only 7 O(1) collision checks. We've taken something that was previously prohibitively expensive, and brought it down to O(log(n))

***CREATING THE TREE***
- So, we know the benefits of an AABB Tree and what they are, but how do we create one? Well, like all binary trees, we just add objects to an empty tree.
- Let's look at adding an object to our AABB Tree, so we can learn the basic rules of doing this.
- To save on a little time, we are going to jump straight to the `I` box and work from there. Just know that this is a recursive process from the base of the tree.

***ADDING THE SCARE***
- So here we have our ghost outside our boxes, and you'll see 3 options. We can either merge the ghost with the base node (our `I` box), the left box (our floor), or the left box (our `J` box).
- To decide how we are going to do that, we have to figure out which merge has the lowest cost. I've represented these costs with shaded areas there. The costs are calculated a little differently between the base node and it's children, so let's talk through the base node first.
	- This is a very simple calculation. The cost for this is the total volume of the new box, N, added to the volume of the overlap between the original box, I, and our ghost.
- Pretty sizeable cost, all things considered. So let's look at merging with our left child, the floor.
	- Already we can see this is going to be expensive. First we calculate the amount of additional volume added to the parent node, I, and add that to the additional volume of our left box, N, and the original box, our floor. We also add the amount of overlap between our new box, N, and the other side of the branch, J.
- The right child is the same as the left child.
	- We do the same calculations, just swapping left for right and vice versa. We can see this is going to be our winner here. The parent node expansion is the same as left, the new box is quite small, and there is no overlap with the left node, if you ignore my bad drawing.

***DOING IT AGAIN***
- Awesome, easy, we merge with the right node. But how do we merge it? I've represented it here as the left node next to J, but in reality, we are recursively working down this tree, so we'd do this again and again until we can't anymore. So let's speed through one more of those and hopefully that will reinforce the idea.
- So, merging with the J node, this is just the volume of the new box, because there is no overlap between the ghost and the base node, J.
- Merging with Hop Boy on the left, we can see no overlap with the right box, and a pretty small box. Spoilers, this is our winner.
- And on the right, we can see that the box is the same size as our base merge, but with the additional cost of the overlap with the left node, Hop Boy.
- And that's the end of it, we can't merge any further, so let's have one more look at our tree here before we move on.

***WHY ARE WE STILL DOING THIS?***
- Now, I know what you're thinking, "Dom, we're not game developers. While that was an amazing presentation on AABB Trees and, on the basis of this you probably deserve a significant pay rise, but how does this help us?" To reply, first off, thank you very much, that's very kind of you.
- But as to the last point, the most specific things can often provide inspiration when you least expect it. Let's talk about property data.
- When you're working on property data, you end up with a lot of data coming from a lot of different places, and understanding the differences between them can often be pretty confusing, for me at least.
- REDACTED
- Cutting a long story short, when I was working on one of these cards, I noticed a lot of properties were in one of our data layers and couldn't be joined into the next. About 24,000 from one table, and 32,000 from the other.
- It can't be that we have over 56,000 unique properties (in WA) that aren't getting through. We have geometries for both datasets, so I did what any reasonable person would do and implemented an AABB Tree to check every single one and see if they matched up.

***TRIGGER WARNING, CODE TIME***

***OPTIMISATION FIRST***
- So let's jump into some code, actually see something practical with all this lame theory.
- I'll quickly preface this with there are many ways to create an AABB Tree depending on what you are trying to optimise for. Given we are not worried about dynamic bodies, and I did this on a whim, we are looking at some pretty barebones stuff.
- We can probably ignore a lot of this. Most of it is just light memory optimisation in Python.
	- Python's floats and ints are 64 bits by default, so we convert to an unsigned 32 bit integer to half that space.
	- We add some dataclasses with slots to tell python to not just store this as a dictionary under the hood and (I think) write straight to memory. This is way more efficient when you are not mutating or copying your objects, and roughly doubles our performance on its own.
	- For generating the box, all we need to do here is iterate through all the points in the polygon and get the min and max lat and long values
- We've seen the rest of the important chunks of this code earlier, so let's jump further ahead.

***TREE TIME***
- Okay, here we are at the tree. One of the fun aspects of an AABB tree is that a node has exactly 0 or 2 children. So we can create some new dataclasses and have them be seperate for our leaf and branch nodes.
- Adding to our tree is exactly as we described it previously, with a couple of additional steps and checks.
	- If we are at a leaf node, our only option is to create a box that encapsulates our new object and the leaf node, pushing it down one level of depth.
	- If we are at a branch node, we can get to calculating the costs. We create our joined bounding boxes and their volume, and then the rules differ, as we saw before.
		- Our parent node calculates the overlap between the new object and itself.
		- Our children calculate the overlap between there joined box and the other child
		- We then calculate the total costs
			- Our parent node is just the new joined volume and the overlap
			- Our children are the parent box expansion, their own box expansion, and the overlap with their neighbour
		- And then we go with whichever cost is lowest
- And that's all there is to it, really. We just call this function for every new polygon we add to our tree, and that's that. So let's jump on down to actually doing that.

**DO IT**
- We'll skip over all our source specific parsing code 
- And here we have it. We are loading in this file here, which has some 24,000 rows.
- And it's done. 7.4s for Python is pretty good.
- That's all well and good, but let's actually visualise our tree so we can see it in action.

- Seriously though, we do have a visualisation of a map with our boxes that we can appreciate.
- I also created a script to output the tree structure, but it is so wide that trying to render it crashes VSC. I got it open in Notepad++ but I zoomed out to be basically unreadable, and I still could only see a portion on the 4th level down the tree.
- That was using text though, we can do a bit better, by manually painting an image pixel by pixel.
- As a warning, this image is almost 300k pixels wide, which is a good sign, but also means it is hard to look at.
- Now we want to be able to actually iterate over a seperate list of geometries and see if they intersect with our tree. For that, we are using a similar list of 32,000 outputs
- And it's done. We've just compared 56,000 geometries to find overlaps and it only took us 7 seconds.
- Let's see our output. Here we see that, first off, some of our geometries actually intersect with many others, and also that we have 3040 properties that overlap, which we can then investigate further.

**And that's it**
- And that's pretty much all, folks. If we've got some time, I'm happy to take questions and flounder my way to an answer.
