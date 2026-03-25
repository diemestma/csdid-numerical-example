********************************************************************************
* Datos simulados para DiD escalonado
* 4 clusteres, 3 periodos, 2 obs por cluster-periodo (6 obs por cluster = 24 total)
* Tratamiento: cluster 1 → periodo 2, cluster 2 → periodo 3, clusters 3 & 4 → nunca tratado
********************************************************************************

clear all

* Importar
use "simulacion_csdid.dta", clear

**********
* CSDID
* ssc install csdid
**********

* CSDID
csdid y_it, time(periodo) gvar(cohorte_tratamiento) cluster(cluster) method(dripw) agg(group)

csdid y_it, time(periodo) gvar(cohorte_tratamiento) cluster(cluster) method(dripw) agg(simple)

* CSDID manual
quietly {
	
	* 1. ATT(2,t) post-tratamiento (t >= g)
	
	* ATT(2,2)
	scalar dif_21_t = (7.020 - 2.465) 
	scalar dif_21_c = (2.504+4.398)/2 - (0.782+2.888)/2 

	scalar att_22 = dif_21_t - dif_21_c

	* ATT(2,3)
	scalar dif_31_t = (8.686 - 2.465) 
	scalar dif_31_c = (4.579+4.948)/2 - (0.782+2.888)/2 

	scalar att_23 = dif_31_t - dif_31_c
	
	* theta_{G}(2)
	scalar theta_2 = (att_22 + att_23)/2

	* 2. ATT(3,t) post-tratamiento (t >= g)
	
	* ATT(3,3)
	scalar dif_32_t = 10.263 - 5.116 
	scalar dif_32_c = (4.579+4.948)/2 - (2.504+4.398)/2 

	scalar att_33 =  dif_32_t - dif_32_c
	
	* theta_{G}(3)
	scalar theta_3 = att_33
	
	
	* ATT simple manual
	scalar att_s_manual = (theta_2*(2/3) + theta_3*(1/3))
}

	* ATT simple post-tratamiento
	di "ATT simple manual: " round(att_s_manual, 0.0001)

**********
* CSDID - SE JACKKNIFE
* net install csdidjack, from("https://raw.githubusercontent.com/liu-yunhan/csdidjack/main/") replace
**********

csdid y_it, time(periodo) gvar(cohorte_tratamiento) cluster(cluster) method(dripw) agg(simple)
csdidjack

* SE JACKKNIFE manual
quietly {

	* 1. h=1
	scalar h_1 = att_33
	
	* 2. h=2
	scalar h_2 = (att_22 + att_23)/2
	
	* 3. h=3
	
	* - ATT(2,t) post-tratamiento (t >= g)
	
	* ATT(2,2)
	scalar dif_21_t = (7.020 - 2.465) 
	scalar dif_21_c = (4.398 - 2.888) 

	scalar att_22_h3 = dif_21_t - dif_21_c

	* ATT(2,3)
	scalar dif_31_t = (8.686 - 2.465) 
	scalar dif_31_c = (4.948 - 2.888) 

	scalar att_23_h3 = dif_31_t - dif_31_c
	
	* theta_{G}(2)
	scalar theta_2_h3 = (att_22_h3 + att_23_h3)/2

	* - ATT(3,t) post-tratamiento (t >= g)
	
	* ATT(3,3)
	scalar dif_32_t = 10.263 - 5.116 
	scalar dif_32_c = (4.948 - 4.398) 

	scalar att_33_h3 =  dif_32_t - dif_32_c
	
	* theta_{G}(3)
	scalar theta_3_h3 = att_33_h3
	
	* ATT simple post-tratamiento
	scalar h_3 = (theta_2_h3*(2/3) + theta_3_h3*(1/3))
	
	* 4. h=4
	
	* - ATT(2,t) post-tratamiento (t >= g)
	
	* ATT(2,2)
	scalar dif_21_t = (7.020 - 2.465) 
	scalar dif_21_c = (2.504 - 0.782)

	scalar att_22_h4 = dif_21_t - dif_21_c

	* ATT(2,3)
	scalar dif_31_t = (8.686 - 2.465) 
	scalar dif_31_c = (4.579 - 0.782)

	scalar att_23_h4 = dif_31_t - dif_31_c
	
	* theta_{G}(2)
	scalar theta_2_h4 = (att_22_h4 + att_23_h4)/2

	* - ATT(3,t) post-tratamiento (t >= g)
	
	* ATT(3,3)
	scalar dif_32_t = 10.263 - 5.116 
	scalar dif_32_c = (4.579 - 2.504)

	scalar att_33_h4 =  dif_32_t - dif_32_c
	
	* theta_{G}(3)
	scalar theta_3_h4 = att_33_h4
	
	* ATT simple post-tratamiento
	scalar h_4 = (theta_2_h4*(2/3) + theta_3_h4*(1/3))
	
	
	* CV_3
	scalar cv_3_1 = (h_1-att_s_manual)^2 + (h_2-att_s_manual)^2 + (h_3-att_s_manual)^2 + (h_4-att_s_manual)^2
	
	scalar cv_3 = (3/4)*cv_3_1
}

	* SE JACKKNIFE
	di "SE Jackknife: " round(sqrt(cv_3), 0.0001)
	
