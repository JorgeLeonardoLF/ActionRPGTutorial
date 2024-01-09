extends CharacterBody2D


#Used to limit the velocity (how fast player is moving)
const MAX_SPEED = 100
#Used to give some INCREASING speed to movement, limited at MAX_SPEED
const ACCELERATION = 10
#Used to slowly stop player (a friction >= acceleration feels like ice
const FRICTION = 10
#delta is a constant that represent the time it took to process the previous frame
#We need to multiple our movements and stops by it so that if lag happens the movement is still in sync
func _physics_process(delta):
	
	##1: velocity is a member variable for the CharacterBody2D class
	##2: It is a Vector2 type, meaning it has an X axis and Y axis
	##3: Below is a way to get user inputs and turn them into player movement
	var input_vector = Vector2.ZERO
	
	##This will take the strength of an action in the positive direction of a 2D grid 
	##and subtract the strenght from the negative side of the grid
	##EX: Absolute strength to the right (postive) - Absolute strength to the left
	##		|1| - |0| = 1, We move right
	##		|0| - |1| = -1 we move left
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	## For some reason the grid is mirrored, so up is the negative axis and down is the positive axis  
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	##Now that we have inputs, we need to "normalize" it
	##Using the built in function, normalized simple makes it so that any vector point (x,y)
	##	is the same distance, this prevents moving faster in the diagionals compared to the x,y direction
	input_vector = input_vector.normalized()
	
	##now lets take input we recieved and turn into player movement by chaning the memeber variable for velocity (aka change in position)
	##If our input variable is not a zero vector (note that it gets reset to zero every frame at the declaration statement)
	if input_vector != Vector2.ZERO:
		##we take the velocity and INCREASE it (+=) with the ACCELERATION
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.limit_length(MAX_SPEED)
	else:
		##else reset the player velocity vector to zero (stop the movement)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	move_and_collide(velocity)
