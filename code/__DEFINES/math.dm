#define PI 					3.1415
#define SPEED_OF_LIGHT		3e8 //not exact but hey!
#define SPEED_OF_LIGHT_SQ	9e+16
#define INFINITY 			1.#INF

// Converts 255 RGB color values to float and returns that as matrix, where color applied into contrast row.
#define RGB_CONTRAST(r, g, b) list(1,0,0, 0,1,0, 0,0,1, r/255, g/255, b/255)

//Returns the hex value of a decimal number
//len == length of returned string
#define num2hex(X, len) num2text(X, len, 16)

//Returns an integer given a hex input, supports negative values "-ff"
//skips preceding invalid characters
#define hex2num(X) text2num(X, 16)

//"fancy" math for calculating time in ms from tick_usage percentage and the length of ticks
//percent_of_tick_used * (ticklag * 100(to convert to ms)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_lag
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_lag)
#define TICK_USAGE_TO_MS(starting_tickusage) (TICK_DELTA_TO_MS(TICK_USAGE_REAL - starting_tickusage))

//time of day but automatically adjusts to the server going into the next day within the same round.
//for when you need a reliable time number that doesn't depend on byond time.
#define REALTIMEOFDAY (world.timeofday + (MIDNIGHT_ROLLOVER * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( global.rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : global.midnight_rollovers )

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR(x, y) ( round((x) / (y)) * (y) )

// Real modulus that handles decimals
#define MODULUS(x, y) ( (x) - (y) * round((x) / (y)) )

#define PERCENT(val) (round((val)*100, 0.1))

#define CLAMP01(x) (clamp(x, 0, 1))

/// Gets the sign of x, returns -1 if negative, 0 if 0, 1 if positive
#define SIGN(x) sign(x)

// Performs a linear interpolation between a and b.
// Note that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the mean of a and b.
#define LERP(a, b, amount) lerp(a, b, amount)

#define CEILING(x, y) ( -round(-(x) / (y)) * (y) )

#define CEIL(x) ceil(x)

// Similar to clamp but the bottom rolls around to the top and vice versa. min is inclusive, max is exclusive
#define WRAP(val, min, max) ( min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) )

// Cotangent
#define COT(x) (1 / tan(x))

// Secant
#define SEC(x) (1 / cos(x))

// Cosecant
#define CSC(x) (1 / sin(x))

#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))) )

// Greatest Common Divisor - Euclid's algorithm
/proc/Gcd(a, b)
	return b ? Gcd(b, (a) % (b)) : a

// Least Common Multiple
#define LCM(a, b) (abs(a) / Gcd(a, b) * abs(b))

#define INVERSE(x) ( 1/(x) )

// Used for calculating the radioactive strength falloff
#define INVERSE_SQUARE(initial_strength,cur_distance,initial_distance) ( (initial_strength)*((initial_distance)**2/(cur_distance)**2) )

#define IS_ABOUT_EQUAL(a, b, deviation) (deviation ? abs((a) - (b)) <= deviation : abs((a) - (b)) <= 0.1)

#define IS_EVEN(x) (x % 2 == 0)

#define IS_ODD(x) (x % 2 != 0)

// Returns true if val is from min to max, inclusive.
#define IS_IN_RANGE(val, min, max) (min <= val && val <= max)

// Same as above, exclusive.
#define IS_IN_RANGE_EX(val, min, max) (min < val && val < max)

#define IS_INTEGER(x) (round(x) == x)

#define IS_MULTIPLE(x, y) ((x) % (y) == 0)

// Returns the nth root of x.
#define ROOT(n, x) ((x) ** (1 / (n)))

/// Converts a probability/second chance to probability/seconds_per_tick chance
/// For example, if you want an event to happen with a 10% per second chance, but your proc only runs every 5 seconds, do `if(prob(100*SPT_PROB_RATE(0.1, 5)))` or `if(prob(100*SPT_PROB_RATE(0.1, seconds_per_tick)))`
#define SPT_PROB_RATE(prob_per_second, seconds_per_tick) (1 - (1 - (prob_per_second)) ** (seconds_per_tick))

/// Like SPT_PROB_RATE but easier to use, simply put `if(SPT_PROB(10, 5))` or `if(SPT_PROB(10, seconds_per_tick))`
#define SPT_PROB(prob_per_second_percent, seconds_per_tick) (prob(100*SPT_PROB_RATE((prob_per_second_percent)/100, (seconds_per_tick))))
// )

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d		= b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0)
		return
	var/root = sqrt(d)
	. += (-b + root) / bottom
	if(!d)
		return
	. += (-b - root) / bottom

#define TO_DEGREES(radians) ((radians) * 57.2957795)

#define TORADIANS(degrees) ((degrees) * 0.0174532925)

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS((degrees), 360))

#define GET_ANGLE_OF_INCIDENCE(face, input) (MODULUS((face) - (input), 360))

//Finds the shortest angle that angle A has to change to get to angle B. Aka, whether to move clock or counterclockwise.
/proc/closer_angle_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DEGREES(a)
	b = SIMPLIFY_DEGREES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec? -dec : inc

//converts a uniform distributed random number into a normal distributed one
//since this method produces two random numbers, one is saved for subsequent calls
//(making the cost negligble for every second call)
//This will return +/- decimals, situated about mean with standard deviation stddev
//68% chance that the number is within 1stddev
//95% chance that the number is within 2stddev
//98% chance that the number is within 3stddev...etc
#define ACCURACY 10000
/proc/gaussian(mean, stddev)
	var/static/gaussian_next
	var/R1;var/R2;var/working
	if(gaussian_next != null)
		R1 = gaussian_next
		gaussian_next = null
	else
		do
			R1 = rand(-ACCURACY,ACCURACY)/ACCURACY
			R2 = rand(-ACCURACY,ACCURACY)/ACCURACY
			working = R1*R1 + R2*R2
		while(working >= 1 || working==0)
		working = sqrt(-2 * log(working) / working)
		R1 *= working
		gaussian_next = R2 * working
	return (mean + stddev * R1)

var/global/normal_next
/proc/NormalDistr(mean = 0, stddev = 1) //because gaussian() looks... strange. This is Box-Muller transform
	if(normal_next != null)
		. = mean + normal_next * stddev
		normal_next = null
	else
		var/R1 = sqrt(-2.0 * log(rand(1, ACCURACY) / ACCURACY))
		var/R2 = 360 * (rand(0, ACCURACY) / ACCURACY) //because BYOND's cos() and sin() accepts degrees
		. = mean + (R1 * cos(R2)) * stddev
		normal_next = R1 * sin(R2)
	return .
#undef ACCURACY

/proc/get_turf_in_angle(angle, turf/starting, increments)
	var/step_x = sin(angle)
	var/step_y = cos(angle)

	var/valid_x = starting.x
	var/valid_y = starting.y
	var/new_x
	var/new_y

	for(var/i in 1 to increments)
		new_x = valid_x + step_x
		new_y = valid_y + step_y

		if(new_x < 1 || new_x > world.maxx)
			break
		if(new_y < 1 || new_y > world.maxx)
			break

		valid_x = new_x
		valid_y = new_y

	valid_x = round(valid_x, 1)
	valid_y = round(valid_y, 1)

	return locate(valid_x, valid_y, starting.z)

// Returns a list where [1] is all x values and [2] is all y values that overlap between the given pair of rectangles
/proc/get_overlap(x1, y1, x2, y2, x3, y3, x4, y4)
	var/list/region_x1 = list()
	var/list/region_y1 = list()
	var/list/region_x2 = list()
	var/list/region_y2 = list()

	// These loops create loops filled with x/y values that the boundaries inhabit
	// ex: list(5, 6, 7, 8, 9)
	for(var/i in min(x1, x2) to max(x1, x2))
		region_x1["[i]"] = TRUE
	for(var/i in min(y1, y2) to max(y1, y2))
		region_y1["[i]"] = TRUE
	for(var/i in min(x3, x4) to max(x3, x4))
		region_x2["[i]"] = TRUE
	for(var/i in min(y3, y4) to max(y3, y4))
		region_y2["[i]"] = TRUE

	return list(region_x1 & region_x2, region_y1 & region_y2)

#define EXP_DISTRIBUTION(desired_mean) ( -(1/(1/desired_mean)) * log(rand(1, 1000) * 0.001) )

#define LORENTZ_DISTRIBUTION(x, s) ( s*tan(TO_DEGREES(PI*(rand()-0.5))) + x )
#define LORENTZ_CUMULATIVE_DISTRIBUTION(x, y, s) ( (1/PI)*TORADIANS(arctan((x-y)/s)) + 1/2 )

#define RULE_OF_THREE(a, b, x) ((a*x)/b)

// Linear conversion from range of [minx, maxx] to [miny, maxy] regarding the value x. Clamps excesses.
#define TRANSLATE_RANGE(x, minx, maxx, miny, maxy) clamp(((x - minx) * (maxy - miny) / (maxx - minx)) + miny, miny, maxy)

//A parabola y = multiplier*x^2 + pike
#define PARABOLIC_SCALING(x, pike, multiplier) (pike + multiplier * (x ** 2))

#define HYPOTENUSE(Ax, Ay, Bx, By) (sqrt(abs(Ax - Bx) ** 2 + abs(Ay - By) ** 2)) //A squared + B squared = C squared
