										
VSOP87C										
										
Heliocentric rectangular coordinates of planets										
Alt.: ftp://cyrano-se.obspm.fr/pub/3_solar_system/2_platab/README.TXT										
Font: http://neoprogrammics.com/vsop87/										
										
Type of Coordinates: Heliocentric rectangular coordinates in AU (astronomical unit).										
										
Reference System: The coordinates of the VSOP87 version C are given in the inertial 										
reference frame defined by the mean equinox and ecliptic of the date.										
										
This frame is deduced from the inertial frame defined by the dynamical equinox and 										
ecliptic J2000 (JD2451545.0) by precessional moving between J2000 and the epoch of 										
the date.										
										
Time Scale: The time used in VSOP87 theory is dynamical time.										
We can considered this time equal to Terrestrial Time (TT) which is measured by 										
international atomic time TAI. So, the time argument in VSOP87 theory is equal to										
 TAI + 32.184 s.										
										
Font: http://www.astrosurf.com/jephem/astro/ephemeris/et300VSOP_en.htm										
										
										
Heliocentric to Geocentric										
										
Ref.: https://en.wikipedia.org/wiki/Ecliptic_coordinate_system#Conversion_between_celestial_coordinate_systems										
The results of VSOP87C beside are heliocentric coordinates, centered on the Sun. 										
To obtain geocentric coordinates, centered on the Earth, using rectangular coordinates, 										
a simple transformation is all that is needed to convert:										
										
	X = Xobj - XEarth									
	Y = Yobj - YEarth									
	Z = Zobj - ZEarth									
										
Determine the heliocentric rectangular coordinates of the planet to locate (Xobj, Yobj and 										
Zobj) as well as those of Earth (XEarth, YEarth and ZEarth) and subtract. This will now set the 										
position of every planet in a space where the origin is the position of Earth. To verify this, set 										
Xobj, Yobj and Zobj to XEarth, YEarth and ZEarth and, as expected, the new position of Earth 										
is (0, 0, 0), the origin.										
To determine the geocentric position of the Sun, set Xobj, Yobj and Zobj all to zero (since it 										
was at the origin in the heliocentric system). The formula for the Sun can then be simplified to:										
										
	X = -XEarth									
	Y = -YEarth									
	Z = -ZEarth									
										
Font: http://www.caglow.com/info/compute/vsop87										
										
	AU	1,4959787E+11	m							
	Light Speed	299792458	m/s							
	01 day	86400	s							
										
										
Geocentric coordenates of planets										
										
Planetary theories give geometric heliocentric ecliptic coordinates. 										
The first step is to take into account an effect called light aberration : 										
Imagine that someone on a planet sends a signal at instant t. 										
On Earth, we'll recieve the signal at instant t + dt (dT is the time taken 										
by light to go from planet to Earth). 										
So at instant t on Earth, we see the planet at its position at instant t - dt. 										
So if we want to have the apparent coordinates of the planet at instant 										
t on Earth, we must calculate them at instant t - dt.										
										
To handle this, we must :										
										
Compute the position of the Earth at instant t;										
										
And for each planet :										
										
Compute positions at instant t ;										
Calculate dt (we have : dT = EP/c (c = light speed));										
Compute coordinates of the planet at instant t - dt.										
										
This means that the coordinates of the planet must be calculated twice.										
										
Font: http://www.astrosurf.com/jephem/astro/ephemeris/et520transfo_en.htm										
										
										
Geocentric coordenates of moon										
										
The ELPMPP02 allows to compute rectangular geocentric 										
lunar coordinates (positions and velocities) referred to 										
the inertial mean ecliptic and equinox of J2000. It uses 										
the six data files which contain the series of the solution 										
and takes into account the specifications presented in 										
this paper.										
										
The inputs are:										
• The date (TDB): tj in days from J2000 (double precision).										
• The index of the corrections: icor (integer).										
icor = 1: the constants are fitted to LLR observations.										
icor = 2: the constants are fitted to JPL Ephemeris DE405.										
										
The outputs are:										
• The table of rectangular coordinates: 										
xyz(6) (double precision),										
positions xE2000, yE2000, zE2000 (km) and 										
velocities x'E2000, y'E2000, z'E2000 (km/day)										
referred to the inertial mean ecliptic and equinox of J2000.										
										
										
Geoc. Rect. to Geoc. spherical ecliptic coordinates										
										
To transform rectangular into spherical Ecliptic coordinates, use:										
										
tan(Lon) = Y / X										
tan(Lat) = Z / sqrt(X * X  + Y * Y)										
										
Be sure to obtain these to the correct quadrants either manually or 										
by using atan2(). 										
										
These can then be quickly converted to equatorial coordinates using 										
the typical ecliptic-to-equatorial formulas.										
										
Font: http://www.caglow.com/info/compute/vsop87										
										
										
tan(Lon) = Y / X  ==> Lon = ATAN2(x;y) * (180 / PI)										
										
tan(Lat) = Z / sqrt(X * X + Y * Y) ==> 										
Lat = ATAN2(RAIZ(POTÊNCIA(X;2) + POTÊNCIA(Y;2));Z) * (180 / PI)										
										
Font: http://idlastro.gsfc.nasa.gov/ftp/pro/astro/planet_coords.pro										
										
										
            0 <= RA <= 360		            -90 <= Decl <= 90								
										
            Do While RA < 0		            Do While Decl < -360								
               RA = RA + 360		                Decl = Decl + 360								
            Loop		                    Loop								
            		            								
            Do While RA > 360		            Do While Decl > 360								
                RA = RA - 360		                Decl = Decl - 360								
            Loop		                    Loop								
		            								
		                                    Do While Decl < -90								
		                                        Decl = Decl + 90								
		                                    Loop								
		            								
		                                    Do While Decl > 90								
		                                        Decl = Decl - 90								
		                                    Loop								
										
										
GPAstro					Public Enum GPOptions					
1	Sun	    gpSun = 1			0	-1				
2	Moon	    gpMoon = 2			1	0	gpHelioRect = 0			
3	Mars	    gpMars = 3			2	2	gpHRLightTime = 2			
4	Mercury	    gpMercury = 4			3	1	gpGeoRect = 1			
5	Jupter	    gpJupiter = 5			4	4	gpGRLTPAberr = 4			
6	Venus	    gpVenus = 6			5	8	gpGeoSphe = 8			
7	Saturn	    gpSaturn = 7			6	16	gpGSFK5 = 16			
8	Uranus	    gpUranus = 8			7	32	gpGSNutac = 32			
9	Neptune	    gpNeptune = 9			8	64	gpRADecl = 64			
10	Earth	    gpEarth = 10			9	128				
11	EarthDt	    gpEarthDt = 11								
										
										
The effect of annual aberration										
										
Ref: https://en.wikipedia.org/wiki/Aberration_of_light										
Font: Astronomical Algorithms - Jean Meeus - pag. 139 and 212										
										
Let lambda and beta be a star [or planet]'s celestial longitude and latitude,										
k the constant of aberration (20".49552), teta the true (geometric) 										
longitude of the sun, e the eccentricity of the Earth orbitt, and pi the 										
longitude of the perihelion of the orbit.										
Teta can be calculated by the method describe in Chapter 24, while 										
										
e = 0,016708617 - (0,000042037 * T) - (0,0000001236 * (T * T))										
										
pi = 102º.93735 + (1º.71953 * T) + (0º.00046 * (T * T))										
										
Where T is the time in Julian Centuries from the epoch J2000.0, as 										
obtained by the formula (21.1).										
Then the changes in longitude and in latitude of the star [or planet] due 										
to the annual aberration are										
										
delta lambda = -k * cos(teta - lambda) + e * k * cos(pi - lambda) / cos(beta)										
										
delta beta = -k * sin(beta) * (sin(teta - lambda) - e * sin(pi - lambda))										
										
										
Aberration annual efect										
										
Chapter 24, pag. 151										
										
Lo = 280º.46645 + (36000º.76983 * T) + (0º.0003032 * (T * T))										
										
M = 357º.52910 + 35999º.05030 * T - (0º.0001559 * (T * T)) - (0º.00000048 * (T * T * T))										
										
C = + (1º.914600 - (0º.004817 * T) - 0º.000014 * (T * T)) * sin(M)										
       + (0º.019993 - (0º.000101 * T) * sin(2 * M) 										
       + (0º.000290 * sin(3 * M))										
										
Then Sun's true longitude is										
Teta = Lo + C										
										
Formula (21.1) (pag. 131)										
										
Find the time T, measured in Julian centuries from the Epoch J2000.0 (JDE 2451545.0)										
										
T = (JDE - 2451545) / 36525										
Where JDE is the Julian Ephemeris Day, it differs from the Julian Day (JD) by the 										
small quanty delta t (see Chapter 7).										
										
										
Heliocentric [/ Geocentric] Spherical to FK5										
Mean dynamical ecliptic and equinox of the date to FK system										
										
Chapter 31, pag. 207										
										
Reference frame Mean dynamical ecliptic and equinox of the date differs										
very slightly from the standard FK5 system. The conversion of L and B to the										
FK5 system can be performed as follows, where T is the time in centuries 										
from 2000.0, or T = 10 * tau.										
										
Calculate:										
										
L' =  L - (1º.397 * T) - (0º.00031 * (T * T))										
										
Then the corretion to L and B are										
										
delta L = -0".09033 + (0".03916 * (cos(L') + sin(L')) * tan(B))										
										
delta B = +0".03916 * (cos(L') -sin(L'))										
										
Then										
										
L = L + delta L										
										
B = B + delta B										
										
										
Julian Day										
										
	Gregorian Date			 Julian Day					Gregorian Date			 Julian Day	
	04/10/1957 19:26:24		 2.436.116,31 		 2.436.116,31 		29/02/1900 23:59:59		 #NÚM!	
	01/01/2000 12:00:00		 2.451.545,00 		 2.451.545,00 		Date	Serial Date		
	01/01/1999 00:00:00		 2.451.179,50 		 2.451.179,50 		01/03/1900	01/03/1900	 2.415.079,50 	
	27/01/1987 00:00:00		 2.446.822,50 		 2.446.822,50 		01/01/2101	01/01/2101	 2.488.434,50 	
	19/06/1987 12:00:00		 2.446.966,00 		 2.446.966,00 		31/12/9999	2958465,00	 5.373.483,50 	
	27/01/1988 00:00:00		 2.447.187,50 		 2.447.187,50 		31/12/9999	2958465,99998843000		
	19/06/1988 12:00:00		 2.447.332,00 		 2.447.332,00 		31/12/9999 23:59:59		 5.373.484,50 	
	01/01/1900 12:00:00		 #NÚM!		 	 2.415.019,00 		31/12/9999 23:59:59		 #NÚM!	
	27/01/0333 12:00:00		 #NÚM!		 	 1.842.713,00 		01/01/2101 00:00:01		 #NÚM!	
								 2415018,5	 	00/01/1900 00:00:00	
										
										
Nutation										
										
Chapter 22		Ref:								
Pag. 143		www.idlastro.gsfc.nasa.gov/ftp/pro/astro/nutate.pro								
		www.github.com/soniakeys/meeus/blob/master/nutation/nutation.go								
			nut_long	nut_obliq						
	10/04/1987 00:00:00		-3,783736134	9,441719164	Arcseconds					
	2446895,5		-0,001051038	0,0026227	Degrees					
			Mean Obliquity of the Ecliptic (by Laskar)	23,44094629	Degrees					
			True Obliquity of the Ecliptic	23,44356899	Degrees	Pag. 147				
										
										
	D	M	Mprime	F	Omega	Sin	Sdelt	Cos	Cdelt	
0	0	0	0	0	1	-171996	-174.2	92025	8.9	{0, 0, 0, 0, 1, -171996, -174.2, 92025, 8.9},
1	-2	0	0	2	2	-13187	-1.6	5736	-3.1	{-2, 0, 0, 2, 2, -13187, -1.6, 5736, -3.1},
2	0	0	0	2	2	-2274	-0.2	977	-0.5	{0, 0, 0, 2, 2, -2274, -0.2, 977, -0.5},
3	0	0	0	0	2	2062	0.2	-895	0.5	{0, 0, 0, 0, 2, 2062, 0.2, -895, 0.5},
4	0	1	0	0	0	1426	-3.4	54	-0.1	{0, 1, 0, 0, 0, 1426, -3.4, 54, -0.1},
5	0	0	1	0	0	712	0.1	-7	0	{0, 0, 1, 0, 0, 712, 0.1, -7, 0},
6	-2	1	0	2	2	-517	1.2	224	-0.6	{-2, 1, 0, 2, 2, -517, 1.2, 224, -0.6},
7	0	0	0	2	1	-386	-0.4	200	0	{0, 0, 0, 2, 1, -386, -0.4, 200, 0},
8	0	0	1	2	2	-301	0	129	-0.1	{0, 0, 1, 2, 2, -301, 0, 129, -0.1},
9	-2	-1	0	2	2	217	-0.5	-95	0.3	{-2, -1, 0, 2, 2, 217, -0.5, -95, 0.3},
10	-2	0	1	0	0	-158	0	0	0	{-2, 0, 1, 0, 0, -158, 0, 0, 0},
11	-2	0	0	2	1	129	0.1	-70	0	{-2, 0, 0, 2, 1, 129, 0.1, -70, 0},
12	0	0	-1	2	2	123	0	-53	0	{0, 0, -1, 2, 2, 123, 0, -53, 0},
13	2	0	0	0	0	63	0	0	0	{2, 0, 0, 0, 0, 63, 0, 0, 0},
14	0	0	1	0	1	63	0.1	-33	0	{0, 0, 1, 0, 1, 63, 0.1, -33, 0},
15	2	0	-1	2	2	-59	0	26	0	{2, 0, -1, 2, 2, -59, 0, 26, 0},
16	0	0	-1	0	1	-58	-0.1	32	0	{0, 0, -1, 0, 1, -58, -0.1, 32, 0},
17	0	0	1	2	1	-51	0	27	0	{0, 0, 1, 2, 1, -51, 0, 27, 0},
18	-2	0	2	0	0	48	0	0	0	{-2, 0, 2, 0, 0, 48, 0, 0, 0},
19	0	0	-2	2	1	46	0	-24	0	{0, 0, -2, 2, 1, 46, 0, -24, 0},
20	2	0	0	2	2	-38	0	16	0	{2, 0, 0, 2, 2, -38, 0, 16, 0},
21	0	0	2	2	2	-31	0	13	0	{0, 0, 2, 2, 2, -31, 0, 13, 0},
22	0	0	2	0	0	29	0	0	0	{0, 0, 2, 0, 0, 29, 0, 0, 0},
23	-2	0	1	2	2	29	0	-12	0	{-2, 0, 1, 2, 2, 29, 0, -12, 0},
24	0	0	0	2	0	26	0	0	0	{0, 0, 0, 2, 0, 26, 0, 0, 0},
25	-2	0	0	2	0	-22	0	0	0	{-2, 0, 0, 2, 0, -22, 0, 0, 0},
26	0	0	-1	2	1	21	0	-10	0	{0, 0, -1, 2, 1, 21, 0, -10, 0},
27	0	2	0	0	0	17	-0.1	0	0	{0, 2, 0, 0, 0, 17, -0.1, 0, 0},
28	2	0	-1	0	1	16	0	-8	0	{2, 0, -1, 0, 1, 16, 0, -8, 0},
29	-2	2	0	2	2	-16	0.1	7	0	{-2, 2, 0, 2, 2, -16, 0.1, 7, 0},
30	0	1	0	0	1	-15	0	9	0	{0, 1, 0, 0, 1, -15, 0, 9, 0},
31	-2	0	1	0	1	-13	0	7	0	{-2, 0, 1, 0, 1, -13, 0, 7, 0},
32	0	-1	0	0	1	-12	0	6	0	{0, -1, 0, 0, 1, -12, 0, 6, 0},
33	0	0	2	-2	0	11	0	0	0	{0, 0, 2, -2, 0, 11, 0, 0, 0},
34	2	0	-1	2	1	-10	0	5	0	{2, 0, -1, 2, 1, -10, 0, 5, 0},
35	2	0	1	2	2	-8	0	3	0	{2, 0, 1, 2, 2, -8, 0, 3, 0},
36	0	1	0	2	2	7	0	-3	0	{0, 1, 0, 2, 2, 7, 0, -3, 0},
37	-2	1	1	0	0	-7	0	0	0	{-2, 1, 1, 0, 0, -7, 0, 0, 0},
38	0	-1	0	2	2	-7	0	3	0	{0, -1, 0, 2, 2, -7, 0, 3, 0},
39	2	0	0	2	1	-7	0	3	0	{2, 0, 0, 2, 1, -7, 0, 3, 0},
40	2	0	1	0	0	6	0	0	0	{2, 0, 1, 0, 0, 6, 0, 0, 0},
41	-2	0	2	2	2	6	0	-3	0	{-2, 0, 2, 2, 2, 6, 0, -3, 0},
42	-2	0	1	2	1	6	0	-3	0	{-2, 0, 1, 2, 1, 6, 0, -3, 0},
43	2	0	-2	0	1	-6	0	3	0	{2, 0, -2, 0, 1, -6, 0, 3, 0},
44	2	0	0	0	1	-6	0	3	0	{2, 0, 0, 0, 1, -6, 0, 3, 0},
45	0	-1	1	0	0	5	0	0	0	{0, -1, 1, 0, 0, 5, 0, 0, 0},
46	-2	-1	0	2	1	-5	0	3	0	{-2, -1, 0, 2, 1, -5, 0, 3, 0},
47	-2	0	0	0	1	-5	0	3	0	{-2, 0, 0, 0, 1, -5, 0, 3, 0},
48	0	0	2	2	1	-5	0	3	0	{0, 0, 2, 2, 1, -5, 0, 3, 0},
49	-2	0	2	0	1	4	0	0	0	{-2, 0, 2, 0, 1, 4, 0, 0, 0},
50	-2	1	0	2	1	4	0	0	0	{-2, 1, 0, 2, 1, 4, 0, 0, 0},
51	0	0	1	-2	0	4	0	0	0	{0, 0, 1, -2, 0, 4, 0, 0, 0},
52	-1	0	1	0	0	-4	0	0	0	{-1, 0, 1, 0, 0, -4, 0, 0, 0},
53	-2	1	0	0	0	-4	0	0	0	{-2, 1, 0, 0, 0, -4, 0, 0, 0},
54	1	0	0	0	0	-4	0	0	0	{1, 0, 0, 0, 0, -4, 0, 0, 0},
55	0	0	1	2	0	3	0	0	0	{0, 0, 1, 2, 0, 3, 0, 0, 0},
56	0	0	-2	2	2	-3	0	0	0	{0, 0, -2, 2, 2, -3, 0, 0, 0},
57	-1	-1	1	0	0	-3	0	0	0	{-1, -1, 1, 0, 0, -3, 0, 0, 0},
58	0	1	1	0	0	-3	0	0	0	{0, 1, 1, 0, 0, -3, 0, 0, 0},
59	0	-1	1	2	2	-3	0	0	0	{0, -1, 1, 2, 2, -3, 0, 0, 0},
60	2	-1	-1	2	2	-3	0	0	0	{2, -1, -1, 2, 2, -3, 0, 0, 0},
61	0	0	3	2	2	-3	0	0	0	{0, 0, 3, 2, 2, -3, 0, 0, 0},
62	2	-1	0	2	2	-3	0	0	0	{2, -1, 0, 2, 2, -3, 0, 0, 0},
										
To complete the calculation of the planet's  apparent position, the corrections for 										
nutation should be aplied. This is achieved by calculating the nutation in longitude 										
(delta psi) and in obliquity (delta epsilon), as explained in Chapter 21. Add delta psi 										
to the planet's geocentric longitude, and delta epsilon to the mean obliquity 										
epsilon 0 of the ecliptic. The apparent right ascension na declination of the 										
planet can then be deduced by means of formula (12.3) and (12.4)										
										
										
Transformation of Coordinates										
										
12.3										
										
tan(alfa) = (sin(lambda) * cos(epsilon) - tan(beta) * sin(epsilon)) / cos(lambda)										
										
Pag. 87 - 89										
										
12.4										
										
sin(delta) = sin(beta) * cos(epsilon) + cos(beta) * sin(epsilon) * sin(lambda)										
										
										
Simbols:										
										
alfa = right ascencion (in hours, minutes and seconds of time -> convert degree by 15)										
										
delta = declination (positive if north of the celestial equador, degative if south)										
										
lambda = ecliptical (or celestial) longitude, measured from the vernal equinox along the ecliptic										
										
beta = ecliptical (or celestial) latitude, positive if north of the ecliptic, negative if south										
										
l = galactic longitude										
										
b = galactic latitude										
										
h = altitude, positive above the horizon, negative below										
										
A = azimuth, measured westwards from the South. South(0º), West(90º), North(180º), East(270º).										
										
Apparent equatorial coordinates (right ascension and declination)										
										
Horizon coordinates (zenith distance and azimuth)										
										
										
Euler Method?										
http://idlastro.gsfc.nasa.gov/ftp/pro/astro/astro.pro										
METHOD:										
;      ASTRO uses PRECESS to compute precession, and EULER to compute										
;      coordinate conversions.   The procedure GET_COORDS is used to										
;      read the coordinates, and ADSTRING to format the RA,Dec output.										
										
										
										
Returning Errors From VBA Functions										
										
Font: http://www.cpearson.com/excel/ReturningErrors.aspx										
										
If you use VBA or another COM language to create User Defined Functions (functions that are called directly 										
from worksheet cells) in a module or add-in, you likely will need to return an error value under some 										
circumstances. For example, if a function requires a positive number as a parameter and the user passes in 										
a negative number, you should return a #VALUE error. You might be tempted to return a text string that looks 										
like an error value, but this is not a good idea. Excel will not recognize the text string, for example #VALUE, as 										
a real error, so many functions and formulas may misbehave, especially ISERROR, ISERR, and IFERROR, and ISNA. 										
These functions require a real error value.										
										
VBA provides a function called CVErr that takes a numeric input parameter specifying the error and returns 										
a real error value that Excel will recognize as an error. The values of the input parameter to CVErr are in the 										
XLCVError Enum and are as follows:										
										
xlErrDiv0 (= 2007) returns a #DIV/0! error.										
xlErrNA (= 2042) returns a #N/A error.										
xlErrName (= 2029) returns a #NAME? error.										
xlErrNull (= 2000) returns a #NULL! error.										
xlErrNum (= 2036) returns a #NUM! error.										
xlErrRef (= 2023) returns a #REF! error.										
xlErrValue (= 2015) returns a #VALUE! error.										
										
The only legal values of the input parameter to CVErr function are those listed above. Any other value causes 										
CVErr to return a#VALUE. This means, unfortunately, that you cannot create your own custom error values. 										
In order to return an error value, the function's return data type must be a Variant. If the return type is any other 										
data type, the CVErr function will terminate VBA execution and Excel will report a #VALUE error in the cell.										
										
Note that these errors are meaningful only to Excel and have nothing at all to do with the Err object used to 										
work with runtime errors in VBA code.										
										
										
										
Degree / Hour stamp										
						Stamp	NumDec			
Degree decimal to hour, minute and second						1	5			
										
	134,7946545070		8h 59' 10".717081669101560			8h 59' 10".71708				
										
	-316,1746574035		-21h 4' 41".917776840236911			-21h 04' 41".91777				
										
						Stamp	NumDec			
Degree decimal to degree, minute and second						2	9			
										
	-18,8874413208		-18º 53' 14".788754902947403			-18º 53' 14".788754902				
										
	13,7388321671		13º 44' 19".795801500239776			13º 44' 19".795801500				
										
										
Stamp Degree to Degree										
							NumDec			
String in degree, arcmin and arcsec to degree and decimals							15			
										
	5º 55' 14".78744		5,92077428929589			5,920774288888890				
										
	316º 10' 28".76665		316,17465740350100			316,174657402778000				
										
										
	0º 54' 54".56976		0,91515826914034			0,915158266666667				
										
	-18º 53' 14".78875		-18,88744132080640			-18,887441319444400				
										
							NumDec			
String in hour, minute and second to degree and decimals							15			
										
	0h 23' 40".98582		5,92077428929589			5,920774250000000				
										
	21h 04' 41".91777		316,17465740350100			316,174657375000000				
										
										
	0h 03' 39".63798		0,91515826914034			0,915158250000000				
										
	-1h 15' 32".98591		-18,88744132080640			-18,887441291666700				
										
										
										
										
										
