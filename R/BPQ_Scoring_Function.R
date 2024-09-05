######################################################################################################
#
# BPQ-SF Scoring R Script
#
# Updated: 9.8.2021
#
#
# Authors:
# Logan Holmes, Indiana University (lgholmes@iu.edu)
# Evan Nix, Indiana University (ejnix@iu.edu)
# Jacek Kolacz, Indiana University (jkolacz@iu.edu)
#
#
# Read in all tables and functions then run BPQ_all_scoring on data frame with item-level data to
# generate raw scores, percentile ranks, and t-scores
#
#
# BPQ Citation:
#
# Porges, S. W. (1993). Body Perception Questionnaire. Laboratory of
# Developmental Assessment, University of Maryland.
#
#
#
# BPQ manual and scoring document available online:
# http://stephenporges.com/images/score.pdf
#
#
#
# BPQ Psychometric Paper Citation:
#
# Cabrera, A., Kolacz, J., Pailhez, G., Bulbena-Cabre, A., Bulbena, A., & Porges, S. W. (2018).
# Assessing body awareness and autonomic reactivity: Factor structure and psychometric
# properties of the Body Perception Questionnaire-Short Form (BPQ-SF). International
# Journal of Methods in Psychiatric Research 27(3), e1596. doi: 10.1002/mpr.1596
#
#
####################################################################################################

# Dependencies -------------------------------------------------------------------------------------
# requireNamespace('dplyr', quietly = T)


# setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 2020 Percentile and T Score Tables --------------------------------------------------------------------
ATable <- data.frame(
  "raw" = seq(26, 130),
  "percents" = c(0.01292407, 0.02854066, 0.0360797, 0.04658051, 0.05735057, 0.06892838, 0.08319871, 0.09693053, 0.11039311, 0.12520194,
                 0.14297254, 0.16289715, 0.18309101, 0.20193861, 0.21943996, 0.23747981, 0.25713516, 0.27894453, 0.29833064, 0.31502423,
                 0.33225633, 0.35083468, 0.37022079, 0.38718363, 0.40522348, 0.42487884, 0.44372644, 0.46149704, 0.48007539, 0.49730749,
                 0.51238557, 0.52961766, 0.5455035, 0.56112009, 0.57592892, 0.59208401, 0.60796984, 0.62224017, 0.637049, 0.65239634,
                 0.66747442, 0.68012924, 0.69116855, 0.70274637, 0.71647819, 0.72967151, 0.74098008, 0.74986537, 0.75901992, 0.76978998,
                 0.77894453, 0.78594507, 0.79563813, 0.80586968, 0.81206247, 0.8174475, 0.82310178, 0.83037157, 0.83871836, 0.84437264,
                 0.84868067, 0.8546042, 0.86187399, 0.86806677, 0.87318255, 0.87991384, 0.88556812, 0.88960689, 0.89310716, 0.89633818,
                 0.90037695, 0.90522348, 0.91060851, 0.91545504, 0.9189553, 0.92137857, 0.92568659, 0.92999461, 0.93457189, 0.93941842,
                 0.94264943, 0.9461497, 0.95045773, 0.95530425, 0.95853527, 0.96095854, 0.9633818, 0.96607431, 0.96930533, 0.9722671,
                 0.97495961, 0.97684437, 0.97872913, 0.98088314, 0.9822294, 0.98330641, 0.98401319, 0.98465267, 0.98546042, 0.98788368,
                 0.9911147, 0.99299946, 0.99434572, 0.99542272, 0.99811524),
  "tScores" = c(27.71514, 30.97312, 32.01889, 33.21046, 34.2259, 35.1618, 36.16127, 37.00759, 37.7556, 38.50631, 39.32941, 40.1738,
                40.96352, 41.65283, 42.25914, 42.85567, 43.47797, 44.1402, 44.70792, 45.18341, 45.66309, 46.16932, 46.68731, 47.13333,
                47.60151, 48.10572, 48.58472, 49.03337, 49.50036, 49.93251, 50.31051, 50.74309, 51.14309, 51.5381, 51.91489, 52.32909,
                52.74032, 53.1137, 53.50582, 53.91798, 54.3295, 54.6806, 54.99165, 55.32316, 55.72411, 56.1182, 56.4637, 56.74066,
                57.03153, 57.38155, 57.68633, 57.9243, 58.26142, 58.62776, 58.85522, 59.0568, 59.27251, 59.55635, 59.89204, 60.12593,
                60.30791, 60.56387, 60.88777, 61.17299, 61.41565, 61.74556, 62.03291, 62.2444, 62.43223, 62.60959, 62.83702, 63.11902,
                63.44512, 63.75134, 63.98079, 64.14406, 64.44399, 64.75751, 65.10734, 65.4991, 65.7741, 66.08615, 66.49308, 66.98616,
                67.33936, 67.61919, 67.91355, 68.25993, 68.70681, 69.15209, 69.59273, 69.92545, 70.28181, 70.7234, 71.02138, 71.27396,
                71.4474, 71.61009, 71.82412, 72.53421, 73.70364, 74.57236, 75.33017, 76.06228, 78.96832))
SubTable <- data.frame(
  "raw" = seq(6, 30),
  "percents" = c(0.08858374, 0.22024771, 0.31260097, 0.40360797, 0.49703823, 0.59181475, 0.67959074, 0.74555735, 0.78890684, 0.82498654,
                 0.85783522, 0.88583737, 0.90549273, 0.92245557, 0.93430264, 0.9461497, 0.95611201, 0.96418955, 0.9722671, 0.97845988,
                 0.98465267, 0.99030695, 0.99380722, 0.99542272, 0.99811524),
  "tScores" = c(36.50472, 42.28643, 45.11509, 47.55981, 49.92576, 52.32216, 54.66555, 56.60574, 58.02634, 59.34537, 60.70644, 62.04684,
                63.135, 64.21784, 65.08625, 66.08615, 67.07248, 68.0152, 69.15209, 70.22931, 71.61009, 73.38022, 75.00964, 76.06228,
                78.96832))
SupTable <- data.frame(
  "raw" = seq(15, 75),
  "percents" = c(0.09343026, 0.23613355, 0.32767905, 0.40118471, 0.46257404, 0.51588584, 0.5632741, 0.60716209, 0.64674206, 0.67959074,
                 0.70624663, 0.72859451, 0.74394184, 0.76036618, 0.78029079, 0.79617663, 0.81044696, 0.82633279, 0.83925687, 0.84975767,
                 0.85864297, 0.86672052, 0.87425956, 0.88314486, 0.89203016, 0.89795369, 0.90441572, 0.91168551, 0.9184168, 0.92353258,
                 0.93080237, 0.93780291, 0.94130318, 0.9450727, 0.94911147, 0.95207324, 0.9544965, 0.95745827, 0.96015078, 0.96230479,
                 0.96580506, 0.97011309, 0.97307485, 0.97495961, 0.97684437, 0.97980614, 0.98276791, 0.98428244, 0.98572967, 0.98842219,
                 0.98976844, 0.99030695, 0.9911147, 0.99246096, 0.99434572, 0.99569198, 0.99623048, 0.99644925, 0.99676898, 0.99762722,
                 0.99865374),
  "tScores" = c(36.80076, 42.81205, 45.53669, 47.49718, 49.06049, 50.3983, 51.59276, 52.7193, 53.76539, 54.66555, 55.42453, 56.08568,
                56.55546, 57.07481, 57.73176, 58.28042, 58.79545, 59.39772, 59.91408, 60.35395, 60.74242, 61.11022, 61.4676, 61.90856,
                62.37397, 62.69978, 63.0713, 63.51208, 63.94501, 64.29241, 64.81793, 65.36588, 65.65808, 65.98847, 66.36299, 66.65297,
                66.9011, 67.21923, 67.52438, 67.78082, 68.22429, 68.82458, 69.28039, 69.59273, 69.92545, 70.49761, 71.14598, 71.51521,
                71.89774, 72.70857, 73.17746, 73.38022, 73.70364, 74.30498, 75.33017, 76.26924, 76.72046, 76.92046, 77.23366, 78.23816,
                80.00822))

CRTable <- data.frame(
  "raw" = seq(20, 100),
  "percents" = c(0.05223479, 0.13004847, 0.18336026, 0.23828756, 0.29348411, 0.34168013, 0.38449111, 0.43026387, 0.4728056, 0.50807754,
                 0.54388799, 0.58077544, 0.61200862, 0.64108778, 0.66935918, 0.69224556, 0.71028541, 0.72886376, 0.74878837, 0.76736672,
                 0.78298331, 0.79509962, 0.80613893, 0.81663974, 0.82660205, 0.83817986, 0.84841142, 0.85621971, 0.862951, 0.86887453,
                 0.87425956, 0.87937534, 0.88745288, 0.89418417, 0.89903069, 0.90495423, 0.91033926, 0.91599354, 0.92030156, 0.92460959,
                 0.93026387, 0.9356489, 0.93995692, 0.94291869, 0.94534195, 0.94776521, 0.94991922, 0.95288099, 0.95584276, 0.95772752,
                 0.96068928, 0.96365105, 0.96580506, 0.96742057, 0.96930533, 0.97092084, 0.9722671, 0.97442111, 0.97657512, 0.97792138,
                 0.97899838, 0.98007539, 0.9816909, 0.98438341, 0.98653743, 0.98788368, 0.98922994, 0.9905762, 0.9916532, 0.99299946,
                 0.99407647, 0.99461497, 0.99515347, 0.99569198, 0.99623048, 0.99644987, 0.99654959, 0.99676898, 0.99730749, 0.99808158,
                 0.99892299),
  "tScores" = c(33.76439, 38.73838, 40.97367, 42.88178, 44.56765, 45.92118, 47.06294, 48.24298, 49.31781, 50.20249, 51.10234, 52.03878,
                52.84558, 53.61368, 54.38144, 55.02226, 55.54219, 56.0938, 56.70682, 57.30202, 57.82308, 58.24244, 58.63756, 59.02633,
                59.40822, 59.87005, 60.29644, 60.63488, 60.93674, 61.21087, 61.4676, 61.7187, 62.13093, 62.49091, 62.76048, 63.10308,
                63.42847, 63.78617, 64.07103, 64.36779, 64.77759, 65.1924, 65.54412, 65.79757, 66.01275, 66.23561, 66.44071, 66.73454,
                67.04357, 67.24903, 67.58741, 67.94723, 68.22429, 68.44167, 68.70681, 68.94503, 69.15209, 69.50154, 69.87656, 70.12595,
                70.33488, 70.55308, 70.89996, 71.54089, 72.12601, 72.53421, 72.98381, 73.48532, 73.93388, 74.57236, 75.16667, 75.50072,
                75.86591, 76.26924, 76.72046, 76.92105, 77.01593, 77.23366, 77.83051, 78.91274, 80.68132))
VSFTable <- data.frame(
  "raw" = seq(12, 60),
  "percents" = c(0.01642434, 0.03931072, 0.05519655, 0.07485191, 0.09746904, 0.12412493, 0.15670436, 0.19628433, 0.2358643, 0.27140549,
                 0.30721594, 0.34868067, 0.38879914, 0.42164782, 0.45557351, 0.48896069, 0.52261712, 0.55708131, 0.58804523, 0.61604739,
                 0.6448573, 0.67662897, 0.70786214, 0.73559505, 0.76278945, 0.78486807, 0.80156166, 0.81933226, 0.83467959, 0.84894992,
                 0.862951, 0.87399031, 0.88341411, 0.89337641, 0.90280022, 0.91141626, 0.92460959, 0.93861066, 0.94749596, 0.9544965,
                 0.96042003, 0.96634356, 0.9722671, 0.97630587, 0.97899838, 0.98303716, 0.98761443, 0.99084545, 0.99623048),
  "tScores" = c(28.66072, 32.41259, 34.03571, 35.59422, 37.03891, 38.45389, 39.91905, 41.45032, 42.80331, 43.91432, 44.96243, 46.11115,
                47.1755, 48.0232, 48.88408, 49.72325, 50.56723, 51.43573, 52.22519, 52.95116, 53.71473, 54.58293, 55.4715, 56.29824,
                57.15304, 57.8874, 58.47213, 59.12823, 59.72824, 60.3194, 60.93674, 61.45458, 61.92228, 62.44686, 62.97673, 63.49528,
                64.36779, 65.43215, 66.21045, 66.9011, 67.55581, 68.29579, 69.15209, 69.82814, 70.33488, 71.20954, 72.44953, 73.59307,
                76.72046))



# 2018 Percentile and T Score Tables ----------------------------------------------------------------
ATable_2018 <- data.frame(
  "raw" = seq(26, 130),
  "percents" = c(0.01393035, 0.03084577, 0.03631841, 0.04477612, 0.05721393, 0.07014925, 0.08258706, 0.09402985, 0.10298507,
                 0.10945274, 0.11691542, 0.12736318, 0.14278607, 0.16169154, 0.18009950, 0.19751244, 0.21293532, 0.22487562,
                 0.23830846, 0.25771144, 0.28009950, 0.30000000, 0.32039801, 0.33781095, 0.35522388, 0.37711443, 0.39651741,
                 0.41641791, 0.43383085, 0.44975124, 0.46616915, 0.48208955, 0.49950249, 0.51492537, 0.53034826, 0.54776119,
                 0.56517413, 0.57910448, 0.59203980, 0.60746269, 0.62238806, 0.63432836, 0.64825871, 0.66417910, 0.67960199,
                 0.69452736, 0.70547264, 0.71741294, 0.72786070, 0.73731343, 0.74925373, 0.76318408, 0.77462687, 0.78308458,
                 0.79502488, 0.80796020, 0.81641791, 0.82338308, 0.82985075, 0.83731343, 0.84577114, 0.85472637, 0.86169154,
                 0.86616915, 0.87263682, 0.87960199, 0.88507463, 0.89004975, 0.89701493, 0.90398010, 0.90995025, 0.91492537,
                 0.92089552, 0.92835821, 0.93631841, 0.94228856, 0.94626866, 0.95024876, 0.95323383, 0.95572139, 0.95721393,
                 0.95870647, 0.96119403, 0.96417910, 0.96666667, 0.96915423, 0.97213930, 0.97512438, 0.97960199, 0.98407960,
                 0.98606965, 0.98706468, 0.98855721, 0.98931270, 0.98979178, 0.99054726, 0.99203980, 0.99353234, 0.99434080,
                 0.99502488, 0.99601990, 0.99674674, 0.99735697, 0.99792055, 0.99850746),
  "tScores" = c(28.00758, 31.31494, 32.04894, 33.02236, 34.21400, 35.25320, 36.12122, 36.83659, 37.35276, 37.70556, 38.09451,
                38.61056, 39.32114, 40.12470, 40.85014, 41.49460, 42.03722, 42.44170, 42.88246, 43.49583, 44.17454, 44.75599,
                45.33414, 45.81555, 46.28745, 46.86932, 47.37628, 47.88934, 48.33371, 48.73710, 49.15097, 49.55090, 49.98753,
                50.37421, 50.76145, 51.20007, 51.64101, 51.99603, 52.32795, 52.72712, 53.11759, 53.43339, 53.80624, 54.23896,
                54.66586, 55.08725, 55.40206, 55.75173, 56.06356, 56.35085, 56.72143, 57.16582, 57.54171, 57.82653, 58.23981,
                58.70404, 59.01798, 59.28335, 59.53576, 59.83476, 60.18464, 60.56922, 60.87951, 61.08464, 61.38944, 61.72999,
                62.00743, 62.26793, 62.64724, 63.04569, 63.40449, 63.71724, 64.11121, 64.63672, 65.24583, 65.74279, 66.09703,
                66.47270, 66.77052, 67.03058, 67.19232, 67.35869, 67.64713, 68.01388, 68.33915, 68.68506, 69.13208, 69.62097,
                70.45597, 71.46404, 71.99242, 72.28148, 72.75339, 73.01301, 73.18606, 73.47390, 74.10735, 74.85545, 75.32711,
                75.77553, 76.53753, 77.21099, 77.89064, 78.65851, 79.69271))
SubTable_2018 <- data.frame(
  "raw" = seq(6, 28),
  "percents" = c(0.09004975, 0.22189055, 0.30398010, 0.37910448, 0.45323383, 0.52935323, 0.61094527, 0.68308458, 0.73631841,
                 0.78407960, 0.82388060, 0.85522388, 0.88805970, 0.91890547, 0.93980100, 0.95621891, 0.96766169, 0.97462687,
                 0.98208955, 0.98855721, 0.99402985, 0.99800995, 0.99900498),
  "tScores" = c(36.59551, 42.34176, 44.87013, 46.92166, 48.82505, 50.73644, 52.81784, 54.76342, 56.32036, 57.86046, 59.30256,
                60.59104, 62.16274, 63.97747, 65.53105, 67.08400, 68.47487, 69.53619, 70.98955, 72.75339, 75.13904, 78.79735,
                80.91713))
SupTable_2018 <- data.frame(
  "raw" = seq(15, 69),
  "percents" = c(0.07412935, 0.19104478, 0.26467662, 0.33134328, 0.39253731, 0.44129353, 0.49353234, 0.54278607, 0.58855721,
                 0.62786070, 0.65721393, 0.68805970, 0.71442786, 0.73880597, 0.76368159, 0.78756219, 0.81044776, 0.82686567,
                 0.84179104, 0.85621891, 0.86815920, 0.87910448, 0.88756219, 0.89601990, 0.90398010, 0.90995025, 0.91592040,
                 0.92338308, 0.93283582, 0.93980100, 0.94527363, 0.95174129, 0.95771144, 0.96417910, 0.96915423, 0.97213930,
                 0.97611940, 0.97910448, 0.98022388, 0.98159204, 0.98557214, 0.98750000, 0.98905473, 0.99154229, 0.99402985,
                 0.99500645, 0.99537498, 0.99601990, 0.99751244, 0.99900498, 0.99940391, 0.99965323, 0.99979520, 0.99987212,
                 0.99992629),
  "tScores" = c(35.54291, 41.25947, 43.71006, 45.63793, 47.27288, 48.52310, 49.83787, 51.07455, 52.23835, 53.26193, 54.04871,
                54.90358, 55.66367, 56.39669, 57.18195, 57.97991, 58.79548, 59.41852, 60.01846, 60.63485, 61.17732, 61.70522,
                62.13665, 62.59194, 63.04569, 63.40449, 63.78143, 64.28202, 64.97249, 65.53105, 66.00658, 66.61977, 67.24725,
                68.01388, 68.68506, 69.13208, 69.79487, 70.35595, 70.58395, 70.87800, 71.85452, 72.41403, 72.92262, 73.88541,
                75.13904, 75.76276, 76.02672, 76.53753, 78.08640, 80.91713, 82.40747, 83.92117, 85.33818, 86.56431, 87.95391))
CRTable_2018 <- data.frame(
  "raw" = seq(21, 98),
  "percents" = c(0.04676617, 0.11343284, 0.15323383, 0.19502488, 0.23731343, 0.27860697, 0.31741294, 0.35273632, 0.38805970,
                 0.42139303, 0.45621891, 0.49303483, 0.52587065, 0.55820896, 0.59353234, 0.62587065, 0.64925373, 0.66965174,
                 0.68905473, 0.70497512, 0.72089552, 0.74029851, 0.76268657, 0.78208955, 0.79800995, 0.81144279, 0.82587065,
                 0.84029851, 0.85024876, 0.85870647, 0.86865672, 0.87860697, 0.88557214, 0.89203980, 0.89900498, 0.90547264,
                 0.91492537, 0.92288557, 0.92786070, 0.93333333, 0.94029851, 0.94676617, 0.95223881, 0.95671642, 0.95870647,
                 0.96019900, 0.96268657, 0.96567164, 0.96815920, 0.97064677, 0.97363184, 0.97661692, 0.98009950, 0.98358209,
                 0.98706468, 0.98855721, 0.98917910, 0.98949005, 0.99004975, 0.99104478, 0.99203980, 0.99303483, 0.99402985,
                 0.99552239, 0.99632470, 0.99687366, 0.99724295, 0.99750630, 0.99773739, 0.99800995, 0.99830750, 0.99856923,
                 0.99880228, 0.99901385, 0.99921108, 0.99940114, 0.99959121, 0.99978844),
  "tScores" = c(33.22948, 37.91528, 39.77338, 41.40473, 42.85029, 44.13015, 45.25055, 46.22057, 47.15620, 48.01669, 48.90036,
                49.82540, 50.64894, 51.46430, 52.36641, 53.20936, 53.83306, 54.38952, 54.93173, 55.38764, 55.85504, 56.44266,
                57.14971, 57.79270, 58.34534, 58.83226, 59.37972, 59.95685, 60.37501, 60.74526, 61.20064, 61.68051, 62.03312,
                62.37449, 62.75902, 63.13381, 63.71724, 64.24752, 64.60042, 65.01086, 65.57284, 66.14276, 66.66960, 67.13791,
                67.35869, 67.53000, 67.82751, 68.20672, 68.54403, 68.90385, 69.37074, 69.88412, 70.55808, 71.34085, 72.28148,
                72.75339, 72.96597, 73.07627, 73.28219, 73.67464, 74.10735, 74.59054, 75.13904, 76.13759, 76.80529, 77.34227,
                77.75358, 78.07846, 78.39021, 78.79735, 79.30424, 79.82232, 80.36247, 80.94371, 81.59972, 82.39424, 83.46772,
                85.25224))
VSFTable_2018 <- data.frame(
  "raw" = seq(12, 60),
  "percents" = c(0.02537313, 0.06169154, 0.08557214, 0.11442786, 0.14179104, 0.17014925, 0.20845771, 0.24328358, 0.27114428,
                 0.31442786, 0.36417910, 0.40348259, 0.43482587, 0.46417910, 0.49701493, 0.52736318, 0.55820896, 0.59054726,
                 0.62338308, 0.65422886, 0.68159204, 0.70646766, 0.72935323, 0.74975124, 0.77114428, 0.79303483, 0.81492537,
                 0.83383085, 0.84676617, 0.85721393, 0.87064677, 0.88756219, 0.90199005, 0.91741294, 0.92985075, 0.93830846,
                 0.94676617, 0.95522388, 0.96169154, 0.96567164, 0.97064677, 0.97611940, 0.98109453, 0.98606965, 0.98955224,
                 0.99116915, 0.99253731, 0.99502488, 0.99800995),
  "tScores" = c(30.46381, 34.59272, 36.31464, 37.96688, 39.27693, 40.46424, 41.88216, 43.04221, 43.90644, 45.16662, 46.52690,
                47.55657, 48.35899, 49.10089, 49.92517, 50.68643, 51.46430, 52.28953, 53.14378, 53.96763, 54.72155, 55.43095,
                56.10858, 56.73707, 57.42621, 58.16997, 58.96194, 59.69415, 60.22662, 60.67886, 61.29454, 62.13665, 62.92974,
                63.87878, 64.74680, 65.40728, 66.14276, 66.97764, 67.70662, 68.20672, 68.90385, 69.79487, 70.76898, 71.99242,
                73.09867, 73.72635, 74.34185, 75.77553, 78.79735))


# Functions -------------------------------------------------------------------------------------


#' BPQ_raw_scoring
#'
#' Takes a data frame with columns named "1", "2", "3"... "46" representing the corresponding BPQ items.
#' First step of BPQ_all_scoring.
#' Returns a tibble (a form of data frame) of the BPQ subscores for each row of subject data.
#'
#' @param df Data frame to be scored.
#' @param form Form of questionnaire. Original Form = "OF", Combined Autonomic Reactivity = "CReact", Short form = "SF", Supradiaphragmatic Reactivity = "Supra", Very Short Form = "VSF"
#' @keywords bpq
#' @import dplyr
#' @importFrom stats median
#' @export



BPQ_raw_scoring <- function(df, form = "SF") {
  df <- as_tibble(df)
  df <- mutate_all(df, as.double)
  if (form == "OF") {
    BPQ_aware <- c("1", "3", "5", "6", "7", "9", "12", "15", "16", "17", "18", "19", "22",
                   "24", "25", "26", "28", "29", "31", "32", "33", "40", "42", "43", "44", "45")
    BPQ_sup_react <- c("57", "59", "60", "61", "63", "64", "65", "66", "67", "69", "72", "73", "74", "79", "80")
    BPQ_sub_react <- c("62", "63", "75", "76", "77", "78")
    subscales <- list(BPQ_aware, BPQ_sup_react, BPQ_sub_react)
    NApercents <- tibble(AwarePercentMissing=numeric(), SupraPercentMissing=numeric(), SubPercentMissing=numeric(), CReactPercentMissing=numeric())
  } else if (form == "SF") {
    BPQ_aware <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14",
                   "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26")
    BPQ_sup_react <- c("27", "28", "29", "30", "41", "31", "32", "33", "34", "35", "36", "37",
                       "38", "39", "40")
    BPQ_sub_react <- c("41", "42", "43", "44", "45", "46")
    subscales <- list(BPQ_aware, BPQ_sup_react, BPQ_sub_react)
    NApercents <- tibble(AwarePercentMissing=numeric(), SupraPercentMissing=numeric(), SubPercentMissing=numeric(), CReactPercentMissing=numeric())
  } else if (form == "VSF") {
    BPQ_vsf = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    subscales <- list(BPQ_vsf)
    NApercents <- tibble(PercentMissing=numeric())
  } else if (form == "CReact"){
    BPQ_sup_react <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15")
    BPQ_sub_react <- c("15", "16", "17", "18", "19", "20")
    subscales <- list(BPQ_sup_react, BPQ_sub_react)
    NApercents <- tibble(SupraPercentMissing=numeric(), SubPercentMissing=numeric(), CReactPercentMissing=numeric())
  } else if (form == "Supra"){
    BPQ_sup_react <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15")
    subscales <- list(BPQ_sup_react)
    NApercents <- tibble(SupraPercentMissing=numeric())
  } else {
    stop("form must be one of ['OF', 'SF', 'VSF', 'CReact', 'Supra']")
  }


  #Counting and removing NA values
  for (row in 1:nrow(df)) {
    percentMissing <- c()
    for (scale in subscales) {
      NAcount <- sum(is.na(df[row, scale]))
      percentMissing <- c(percentMissing, 100*(NAcount/length(scale)))
      # Replacing NAs with median of respondent's answers
      med <- median(as.double(df[row,scale]), na.rm = TRUE)
      df[row,] <- mutate_at(df[row,], vars(all_of(scale)), ~ifelse(is.na(.), med, .))
    }
    if (form %in% c("OF", "SF", "CReact")) {
      NAcount <- 100 * sum(is.na(df[row, union(BPQ_sup_react, BPQ_sub_react)])) / length(union(BPQ_sup_react, BPQ_sub_react))
      percentMissing <- c(percentMissing, NAcount)
    }
    names(percentMissing) <- names(NApercents)
    NApercents <- rbind(NApercents, as.list(percentMissing))
  }

  if (form == "VSF") {
    return(tibble(VSF=rowSums(df[,BPQ_vsf]),
                  PercentMissing=NApercents$PercentMissing))
  }

  if (form == "CReact") {
    return(tibble(SupraReact=rowSums(df[,BPQ_sup_react]),
                  SupraPercentMissing=NApercents$SupraPercentMissing,
                  SubReact=rowSums(df[,BPQ_sub_react]),
                  SubPercentMissing=NApercents$SubPercentMissing,
                  CReact=rowSums(df[,union(BPQ_sub_react, BPQ_sup_react)]),
                  CReactPercentMissing=NApercents$CReactPercentMissing,))
  }

  if (form == "Supra") {
    return(tibble(SupraReact=rowSums(df[,BPQ_sup_react]),
                  SupraPercentMissing=NApercents$SupraPercentMissing,))
  }

  return(tibble(Aware=rowSums(df[,BPQ_aware]),
                AwarePercentMissing=NApercents$AwarePercentMissing,
                SupraReact=rowSums(df[,BPQ_sup_react]),
                SupraPercentMissing=NApercents$SupraPercentMissing,
                SubReact=rowSums(df[,BPQ_sub_react]),
                SubPercentMissing=NApercents$SubPercentMissing,
                CReact=rowSums(df[,union(BPQ_sub_react, BPQ_sup_react)]),
                CReactPercentMissing=NApercents$CReactPercentMissing,))
}


#' BPQ_single_scoring
#'
#' Takes a subscore in the form of an integer and a table for the subscore to be referenced in. Function
#' is used by BPQ_per_t_scoring , but is usable independently.
#' Returns a factor containing the given score's percentile rank and t-score, respectively, in the given
#' table.
#'
#' @param val Subscore value to be scored
#' @param table Table for reference
#' @keywords bpq
#' @export


BPQ_single_scoring <- function(val, table) {
  val <- round(val)
  p <- with(table, setNames(percents, raw))[toString(val)]
  t <- with(table, setNames(tScores, raw))[toString(val)]

  return(c(p, t))
}


#' BPQ_per_t_scoring
#'
#' Takes a data frame (such as a tibble produced by BPQ_raw_scoring) of raw subscores and calculates
#' the percentile rank and t-score for each value. Second step of BPQ_all_scoring.
#' Returns a tibble (a form of data frame) of the BPQ subscores and percentile ranks/t-scores for each.
#'
#' @param df Data frame to be scored.
#' @param form Form of questionnaire. Original Form = "OF", All Diaphragmatic Reactivity = "CReact", Short form = "SF", Supradiaphragmatic Reactivity = "Supra", Very Short Form = "VSF"
#' @param version Version of tables to use. "2020" or "2018"
#' @keywords bpq
#' @export


BPQ_per_t_scoring <- function(df, form = "SF", version="2020") {
  if (form %in% c("SF","OF")) {
    Awareness <- data.frame(AwarePercent = NA, AwareTScore = NA)
    Supra_Reactivity <- data.frame(SupPercent = NA, SupTScore = NA)
    Sub_Reactivity <- data.frame(SubPercent = NA, SubTScore = NA)
    Combined_Reactivity <- data.frame(CRPercent = NA, CRTScore = NA)

  } else if (form == "CReact") {
    Supra_Reactivity <- data.frame(SupPercent = NA, SupTScore = NA)
    Sub_Reactivity <- data.frame(SubPercent = NA, SubTScore = NA)
    Combined_Reactivity <- data.frame(CRPercent = NA, CRTScore = NA)

  } else if (form == "VSF") {
    Very_Short_Form <- data.frame(VSFPercent = NA, VSFTScore = NA)

  } else if (form == "Supra") {
    Supra_Reactivity <- data.frame(SupPercent = NA, SupTScore = NA)

  } else {
    stop("form must be one of ['OF', 'SF', 'VSF', 'CReact', 'Supra']")
  }

  if (version == "2018") {
    ATable <- ATable_2018
    SubTable <- SubTable_2018
    SupTable <- SupTable_2018
    CRTable <- CRTable_2018
    VSFTable <- VSFTable_2018
  } else if (version != "2020") {
    stop("version must be one of ['2018, '2020']")
  }

  for (row in seq(nrow(df))) {
    if (form %in% c("SF","OF")) {
      Awareness[row, c("AwarePercent", "AwareTScore")] <- BPQ_single_scoring(df$Aware[row], ATable)
      Supra_Reactivity[row, c("SupPercent", "SupTScore")] <- BPQ_single_scoring(df$SupraReact[row], SupTable)
      Sub_Reactivity[row, c("SubPercent", "SubTScore")] <- BPQ_single_scoring(df$SubReact[row], SubTable)
      Combined_Reactivity[row, c("CRPercent", "CRTScore")] <- BPQ_single_scoring(df$CReact[row], CRTable)

    } else if (form == "CReact"){
      Supra_Reactivity[row, c("SupPercent", "SupTScore")] <- BPQ_single_scoring(df$SupraReact[row], SupTable)
      Sub_Reactivity[row, c("SubPercent", "SubTScore")] <- BPQ_single_scoring(df$SubReact[row], SubTable)
      Combined_Reactivity[row, c("CRPercent", "CRTScore")] <- BPQ_single_scoring(df$CReact[row], CRTable)

    } else if (form == "Supra"){
      Supra_Reactivity[row, c("SupPercent", "SupTScore")] <- BPQ_single_scoring(df$SupraReact[row], SupTable)

    } else {
      Very_Short_Form[row, c("VSFPercent", "VSFTScore")] <- BPQ_single_scoring(df$VSF[row], VSFTable)
    }
  }

  if (form %in% c("SF","OF")) {
    df <- cbind(df, Awareness, Supra_Reactivity, Sub_Reactivity, Combined_Reactivity)
  } else if (form == "CReact") {
    df <- cbind(df, Supra_Reactivity, Sub_Reactivity, Combined_Reactivity)
  } else if (form == "Supra") {
    df <- cbind(df, Supra_Reactivity)
  } else {
    df <- cbind(df, Very_Short_Form)
  }

  return(df)
}



#' BPQ_all_scoring
#'
#' Takes a data frame with columns named "bpq_1", "bpq_2", "bpq_3"... "bpq_46" representing the
#' corresponding BPQ items. Each subject should be a row and the values in these columns
#' should be integers from 1-5, where a 1 is a "Never" response and a 5 is an "Always" response.
#' Returns the given data frame with new columns for BPQ raw scores, percentile ranks, and
#' t-scores.
#'
#' Percentile Rankings are on a 0-1 scale (e.g. 0.25 = 25\%)
#' @param df Data frame to be scored.
#' @param form Form of questionnaire. Original Form = "OF", Diaphragmatic Reactivity (i.e Combined Reactivity) = "CReact", Short form = "SF", Supradiaphragmatic Reactivity = "Supra", Very Short Form = "VSF"
#' @param version Version of tables to use. "2020" or "2018"
#' @keywords bpq
#' @import dplyr
#' @export
#' @examples BPQ_all_scoring(test_data, form = 'SF', version = '2020')
#' BPQ_all_scoring(test_data, form = 'CReact', version = '2018')

BPQ_all_scoring <- function(df, form = "SF", version = "2020") {
  input <- rename_all(select(df, starts_with("bpq_")), .funs = substring, 5)
  return(cbind(df, BPQ_per_t_scoring(BPQ_raw_scoring(input, form), form, version)))
}


#########################################################################################################
#
#Run Scoring (Example with original BPQ form .csv file)
#
#########################################################################################################

# test_data <- read.csv("../../Functions/BPQ Scoring/BPQ SF Scoring Test Data.csv")
#
# test_output <- BPQ_all_scoring(test_data, form = "SF")
