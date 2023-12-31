local PropHandPoker = {
	--(key || `win`, `twopair`, `threekind`, `straight`, `flush`, `fullhouse`, `fourkind`, `straightflush`)
	["AKs"]={"19.82","24.62","5.3","3.15","6.58","2.24","0.13","0.06"},
	["AQs"]={"18.28","24.62","5.3","3.52","6.58","2.24","0.13","0.06"},
	["AJs"]={"17.05","24.62","5.3","3.85","6.58","2.24","0.13","0.06"},
	["ATs"]={"16.11","24.62","5.3","4.19","6.58","2.24","0.13","0.06"},
	["A9s"]={"14.16","24.62","5.3","2.5","6.58","2.24","0.13","0.01"},
	["A8s"]={"13.49","24.62","5.3","2.86","6.58","2.24","0.13","0.02"},
	["A7s"]={"12.95","24.62","5.3","2.86","6.58","2.24","0.13","0.02"},
	["A6s"]={"12.54","24.62","5.3","2.5","6.58","2.24","0.13","0.01"},
	["A5s"]={"12.99","24.62","5.3","4.2","6.58","2.24","0.13","0.06"},
	["A4s"]={"12.82","24.62","5.3","3.85","6.58","2.24","0.13","0.06"},
	["A3s"]={"12.67","24.62","5.3","3.5","6.58","2.24","0.13","0.06"},
	["A2s"]={"12.4","24.62","5.3","3.14","6.58","2.24","0.13","0.05"},
	["AAn"]={"30.87","45.83","15.26","1.23","1.97","8.68","0.84","0.01"},
	["AKn"]={"16.29","24.62","5.3","3.31","1.97","2.24","0.13","0.01"},
	["AQn"]={"14.51","24.62","5.3","3.68","1.97","2.24","0.13","0.01"},
	["AJn"]={"13.13","24.62","5.3","4.06","1.97","2.24","0.13","0.01"},
	["ATn"]={"12.08","24.62","5.3","4.45","1.97","2.24","0.13","0.02"},
	["A9n"]={"9.93","24.62","5.3","2.7","1.97","2.24","0.13","0.02"},
	["A8n"]={"9.16","24.62","5.3","3.06","1.97","2.24","0.13","0.02"},
	["A7n"]={"8.56","24.62","5.3","3.06","1.97","2.24","0.13","0.02"},
	["A6n"]={"8.12","24.62","5.3","2.7","1.97","2.24","0.13","0.02"},
	["A5n"]={"8.6","24.62","5.3","4.45","1.97","2.24","0.13","0.02"},
	["A4n"]={"8.43","24.62","5.3","4.06","1.97","2.24","0.13","0.01"},
	["A3n"]={"8.27","24.62","5.3","3.68","1.97","2.24","0.13","0.01"},
	["A2n"]={"7.96","24.62","5.3","3.32","1.97","2.24","0.13","0.01"},
	["KQs"]={"17.67","24.62","5.3","4.79","6.58","2.24","0.13","0.1"},
	["KJs"]={"16.59","24.62","5.3","5.15","6.58","2.24","0.13","0.1"},
	["KTs"]={"15.7","24.62","5.3","5.52","6.58","2.24","0.13","0.11"},
	["K9s"]={"13.77","24.62","5.3","3.81","6.58","2.24","0.13","0.06"},
	["K8s"]={"12.42","24.62","5.3","2.51","6.58","2.24","0.13","0.02"},
	["K7s"]={"11.93","24.62","5.3","2.87","6.58","2.24","0.13","0.02"},
	["K6s"]={"11.53","24.62","5.3","2.86","6.58","2.24","0.13","0.02"},
	["K5s"]={"11.25","24.62","5.3","2.91","6.58","2.24","0.13","0.02"},
	["K4s"]={"11.1","24.62","5.3","2.55","6.58","2.24","0.13","0.01"},
	["K3s"]={"11.04","24.62","5.3","2.2","6.58","2.24","0.13","0.01"},
	["K2s"]={"10.94","24.62","5.3","1.84","6.58","2.24","0.13","0.01"},
	["KKn"]={"25.82","45.83","15.26","1.22","1.97","8.68","0.84","0.01"},
	["KQn"]={"14.11","24.62","5.3","5.03","1.97","2.24","0.13","0.01"},
	["KJn"]={"12.83","24.62","5.3","5.4","1.97","2.24","0.13","0.01"},
	["KTn"]={"11.87","24.62","5.3","5.77","1.97","2.24","0.13","0.02"},
	["K9n"]={"9.69","24.62","5.3","4.02","1.97","2.24","0.13","0.02"},
	["K8n"]={"8.22","24.62","5.3","2.7","1.97","2.24","0.13","0.02"},
	["K7n"]={"7.65","24.62","5.3","3.07","1.97","2.24","0.13","0.02"},
	["K6n"]={"7.25","24.62","5.3","3.07","1.97","2.24","0.13","0.02"},
	["K5n"]={"6.91","24.62","5.3","3.12","1.97","2.24","0.13","0.02"},
	["K4n"]={"6.78","24.62","5.3","2.72","1.97","2.24","0.13","0.01"},
	["K3n"]={"6.69","24.62","5.3","2.35","1.97","2.24","0.13","0.01"},
	["K2n"]={"6.6","24.62","5.3","1.99","1.97","2.24","0.13","0.01"},
	["QJs"]={"16.15","24.62","5.3","6.81","6.58","2.24","0.13","0.15"},
	["QTs"]={"15.39","24.62","5.3","7.17","6.58","2.24","0.13","0.15"},
	["Q9s"]={"13.44","24.62","5.3","5.47","6.58","2.24","0.13","0.11"},
	["Q8s"]={"12.09","24.62","5.3","4.17","6.58","2.24","0.13","0.06"},
	["Q7s"]={"10.94","24.62","5.3","2.87","6.58","2.24","0.13","0.02"},
	["Q6s"]={"10.54","24.62","5.3","3.2","6.58","2.24","0.13","0.02"},
	["Q5s"]={"10.29","24.62","5.3","3.25","6.58","2.24","0.13","0.02"},
	["Q4s"]={"10.2","24.62","5.3","2.91","6.58","2.24","0.13","0.02"},
	["Q3s"]={"10.11","24.62","5.3","2.55","6.58","2.24","0.13","0.01"},
	["Q2s"]={"10.04","24.62","5.3","2.19","6.58","2.24","0.13","0.01"},
	["QQn"]={"21.91","45.83","15.26","1.6","1.97","8.68","0.84","0.01"},
	["QJn"]={"12.58","24.62","5.3","7.13","1.97","2.24","0.13","0.02"},
	["QTn"]={"11.68","24.62","5.3","7.48","1.97","2.24","0.13","0.02"},
	["Q9n"]={"9.55","24.62","5.3","5.73","1.97","2.24","0.13","0.02"},
	["Q8n"]={"8.07","24.62","5.3","4.4","1.97","2.24","0.13","0.02"},
	["Q7n"]={"6.79","24.62","5.3","3.08","1.97","2.24","0.13","0.02"},
	["Q6n"]={"6.38","24.62","5.3","3.45","1.97","2.24","0.13","0.02"},
	["Q5n"]={"6.1","24.62","5.3","3.49","1.97","2.24","0.13","0.02"},
	["Q4n"]={"5.98","24.62","5.3","3.12","1.97","2.24","0.13","0.02"},
	["Q3n"]={"5.87","24.62","5.3","2.74","1.97","2.24","0.13","0.01"},
	["Q2n"]={"5.81","24.62","5.3","2.35","1.97","2.24","0.13","0.01"},
	["JTs"]={"15.34","24.62","5.3","8.81","6.58","2.24","0.13","0.2"},
	["J9s"]={"13.45","24.62","5.3","7.12","6.58","2.24","0.13","0.15"},
	["J8s"]={"12.11","24.62","5.3","5.82","6.58","2.24","0.13","0.11"},
	["J7s"]={"10.9","24.62","5.3","4.52","6.58","2.24","0.13","0.06"},
	["J6s"]={"9.84","24.62","5.3","3.22","6.58","2.24","0.13","0.02"},
	["J5s"]={"9.58","24.62","5.3","3.61","6.58","2.24","0.13","0.02"},
	["J4s"]={"9.47","24.62","5.3","3.27","6.58","2.24","0.13","0.02"},
	["J3s"]={"9.41","24.62","5.3","2.91","6.58","2.24","0.13","0.02"},
	["J2s"]={"9.32","24.62","5.3","2.55","6.58","2.24","0.13","0.01"},
	["JJn"]={"18.91","45.83","15.26","1.99","1.97","8.68","0.84","0.02"},
	["JTn"]={"11.81","24.62","5.3","9.21","1.97","2.24","0.13","0.02"},
	["J9n"]={"9.71","24.62","5.3","7.44","1.97","2.24","0.13","0.02"},
	["J8n"]={"8.26","24.62","5.3","6.12","1.97","2.24","0.13","0.02"},
	["J7n"]={"6.91","24.62","5.3","4.76","1.97","2.24","0.13","0.02"},
	["J6n"]={"5.76","24.62","5.3","3.44","1.97","2.24","0.13","0.02"},
	["J5n"]={"5.49","24.62","5.3","3.87","1.97","2.24","0.13","0.02"},
	["J4n"]={"5.35","24.62","5.3","3.49","1.97","2.24","0.13","0.02"},
	["J3n"]={"5.29","24.62","5.3","3.11","1.97","2.24","0.13","0.02"},
	["J2n"]={"5.23","24.62","5.3","2.73","1.97","2.24","0.13","0.01"},
	["T9s"]={"13.68","24.62","5.3","8.77","6.58","2.24","0.13","0.2"},
	["T8s"]={"12.36","24.62","5.3","7.47","6.58","2.24","0.13","0.16"},
	["T7s"]={"11.14","24.62","5.3","6.17","6.58","2.24","0.13","0.11"},
	["T6s"]={"9.98","24.62","5.3","4.85","6.58","2.24","0.13","0.06"},
	["T5s"]={"9.01","24.62","5.3","3.61","6.58","2.24","0.13","0.02"},
	["T4s"]={"8.9","24.62","5.3","3.61","6.58","2.24","0.13","0.02"},
	["T3s"]={"8.83","24.62","5.3","3.26","6.58","2.24","0.13","0.02"},
	["T2s"]={"8.77","24.62","5.3","2.91","6.58","2.24","0.13","0.02"},
	["TTn"]={"16.65","45.83","15.26","2.37","1.97","8.68","0.84","0.02"},
	["T9n"]={"10.11","24.62","5.3","9.16","1.97","2.24","0.13","0.02"},
	["T8n"]={"8.67","24.62","5.3","7.81","1.97","2.24","0.13","0.02"},
	["T7n"]={"7.32","24.62","5.3","6.49","1.97","2.24","0.13","0.02"},
	["T6n"]={"6.11","24.62","5.3","5.15","1.97","2.24","0.13","0.02"},
	["T5n"]={"5.05","24.62","5.3","3.87","1.97","2.24","0.13","0.02"},
	["T4n"]={"4.89","24.62","5.3","3.86","1.97","2.24","0.13","0.02"},
	["T3n"]={"4.82","24.62","5.3","3.49","1.97","2.24","0.13","0.02"},
	["T2n"]={"4.77","24.62","5.3","3.12","1.97","2.24","0.13","0.02"},
	["98s"]={"12.36","24.62","5.3","8.75","6.58","2.24","0.13","0.2"},
	["97s"]={"11.44","24.62","5.3","7.43","6.58","2.24","0.13","0.16"},
	["96s"]={"10.38","24.62","5.3","6.13","6.58","2.24","0.13","0.11"},
	["95s"]={"9.32","24.62","5.3","4.88","6.58","2.24","0.13","0.07"},
	["94s"]={"8.44","24.62","5.3","3.22","6.58","2.24","0.13","0.02"},
	["93s"]={"8.36","24.62","5.3","3.21","6.58","2.24","0.13","0.02"},
	["92s"]={"8.29","24.62","5.3","2.86","6.58","2.24","0.13","0.02"},
	["99n"]={"15.2","45.83","15.26","2.32","1.97","8.68","0.84","0.02"},
	["98n"]={"8.74","24.62","5.3","9.1","1.97","2.24","0.13","0.02"},
	["97n"]={"7.76","24.62","5.3","7.78","1.97","2.24","0.13","0.02"},
	["96n"]={"6.59","24.62","5.3","6.44","1.97","2.24","0.13","0.02"},
	["95n"]={"5.47","24.62","5.3","5.16","1.97","2.24","0.13","0.02"},
	["94n"]={"4.55","24.62","5.3","3.44","1.97","2.24","0.13","0.02"},
	["93n"]={"4.42","24.62","5.3","3.46","1.97","2.24","0.13","0.02"},
	["92n"]={"4.37","24.62","5.3","3.07","1.97","2.24","0.13","0.02"},
	["87s"]={"11.72","24.62","5.3","8.72","6.58","2.24","0.13","0.2"},
	["86s"]={"10.87","24.62","5.3","7.42","6.58","2.24","0.13","0.15"},
	["85s"]={"9.85","24.62","5.3","6.18","6.58","2.24","0.13","0.11"},
	["84s"]={"8.9","24.62","5.3","4.52","6.58","2.24","0.13","0.06"},
	["83s"]={"8.06","24.62","5.3","2.87","6.58","2.24","0.13","0.02"},
	["82s"]={"7.94","24.62","5.3","2.86","6.58","2.24","0.13","0.02"},
	["88n"]={"14.11","45.83","15.26","2.32","1.97","8.68","0.84","0.02"},
	["87n"]={"8.14","24.62","5.3","9.08","1.97","2.24","0.13","0.02"},
	["86n"]={"7.22","24.62","5.3","7.77","1.97","2.24","0.13","0.02"},
	["85n"]={"6.15","24.62","5.3","6.48","1.97","2.24","0.13","0.02"},
	["84n"]={"5.09","24.62","5.3","4.78","1.97","2.24","0.13","0.02"},
	["83n"]={"4.22","24.62","5.3","3.07","1.97","2.24","0.13","0.02"},
	["82n"]={"4.11","24.62","5.3","3.07","1.97","2.24","0.13","0.02"},
	["76s"]={"11.21","24.62","5.3","8.72","6.58","2.24","0.13","0.2"},
	["75s"]={"10.46","24.62","5.3","7.46","6.58","2.24","0.13","0.16"},
	["74s"]={"9.53","24.62","5.3","5.83","6.58","2.24","0.13","0.11"},
	["73s"]={"8.58","24.62","5.3","4.15","6.58","2.24","0.13","0.06"},
	["72s"]={"7.74","24.62","5.3","2.5","6.58","2.24","0.13","0.01"},
	["77n"]={"13.28","45.83","15.26","2.32","1.97","8.68","0.84","0.02"},
	["76n"]={"7.7","24.62","5.3","9.11","1.97","2.24","0.13","0.02"},
	["75n"]={"6.85","24.62","5.3","7.82","1.97","2.24","0.13","0.02"},
	["74n"]={"5.86","24.62","5.3","6.11","1.97","2.24","0.13","0.02"},
	["73n"]={"4.85","24.62","5.3","4.4","1.97","2.24","0.13","0.02"},
	["72n"]={"3.98","24.62","5.3","2.68","1.97","2.24","0.13","0.02"},
	["65s"]={"10.92","24.62","5.3","8.78","6.58","2.24","0.13","0.2"},
	["64s"]={"10.17","24.62","5.3","7.12","6.58","2.24","0.13","0.15"},
	["63s"]={"9.27","24.62","5.3","5.47","6.58","2.24","0.13","0.11"},
	["62s"]={"8.32","24.62","5.3","3.81","6.58","2.24","0.13","0.06"},
	["66n"]={"12.67","45.83","15.26","2.31","1.97","8.68","0.84","0.02"},
	["65n"]={"7.37","24.62","5.3","9.14","1.97","2.24","0.13","0.02"},
	["64n"]={"6.62","24.62","5.3","7.45","1.97","2.24","0.13","0.02"},
	["63n"]={"5.65","24.62","5.3","5.74","1.97","2.24","0.13","0.02"},
	["62n"]={"4.64","24.62","5.3","4.01","1.97","2.24","0.13","0.02"},
	["54s"]={"10.67","24.62","5.3","8.81","6.58","2.24","0.13","0.2"},
	["53s"]={"9.97","24.62","5.3","7.15","6.58","2.24","0.13","0.15"},
	["52s"]={"9.06","24.62","5.3","5.53","6.58","2.24","0.13","0.11"},
	["55n"]={"12.02","45.83","15.26","2.37","1.97","8.68","0.84","0.02"},
	["54n"]={"7.2","24.62","5.3","9.21","1.97","2.24","0.13","0.02"},
	["53n"]={"6.42","24.62","5.3","7.49","1.97","2.24","0.13","0.02"},
	["52n"]={"5.47","24.62","5.3","5.78","1.97","2.24","0.13","0.02"},
	["43s"]={"9.61","24.62","5.3","6.82","6.58","2.24","0.13","0.15"},
	["42s"]={"8.92","24.62","5.3","5.15","6.58","2.24","0.13","0.1"},
	["44n"]={"11.88","45.83","15.26","1.99","1.97","8.68","0.84","0.02"},
	["43n"]={"6.05","24.62","5.3","7.12","1.97","2.24","0.13","0.02"},
	["42n"]={"5.31","24.62","5.3","5.39","1.97","2.24","0.13","0.01"},
	["32s"]={"8.59","24.62","5.3","4.8","6.58","2.24","0.13","0.1"},
	["33n"]={"11.83","45.83","15.26","1.61","1.97","8.68","0.84","0.01"},
	["32n"]={"4.97","24.62","5.3","5.02","1.97","2.24","0.13","0.01"},
	["22n"]={"11.82","45.83","15.26","1.24","1.97","8.68","0.84","0.01"},
}
return PropHandPoker