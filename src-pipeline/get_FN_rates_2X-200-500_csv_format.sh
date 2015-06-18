#!/bin/bash                                                                      

MODELPATH=~/AGBsvdquartets/2X-200-500
cd $MODELPATH

rm -f FN_rates_mammalian_simulated.csv
touch FN_rates_mammalian_simulated.csv
echo "model,# taxa,method,# sites,# genes,replicate,FN rate" >> FN_rates_mammalian_simulated.csv

#FN rates for ASTRAL, NJst, and RAxML with 10 runs
for N in 10 25 50 100 200; do
    for K in 50 100 200; do
	# svdquartets_qmc astral astral_fasttree_genetrees njst njst_fasttree_genetrees RAxML_bestTree.concatenation
	for METHOD in astral_fasttree_genetrees njst_fasttree_genetrees; do

            #remove old files
	    rm -f temp_${METHOD}_${N}_${K}
	    touch temp_${METHOD}_${N}_${K}
	    
            #calculate FN rates for ${METHOD}
	    for SPECIESNUMBER in {1..20}; do 
		~/phylogenetic_tools/tree_comp/compareTrees.missingBranch ~/scratch/2X-200-500/R${SPECIESNUMBER}/S_relabeled_tree.trees ${MODELPATH}/R${SPECIESNUMBER}/${METHOD}_${N}_sites_${K}_genes.tree >> ${MODELPATH}/temp_${METHOD}_${N}_${K}
		TEMP=$(awk -vORS= '{ print $3 }' temp_${METHOD}_${N}_${K})
		echo "15-taxon,15,"${METHOD}","${N}","${K}","${SPECIESNUMBER}","${TEMP} >> FN_rates_mammalian_simulated.csv
		rm temp_${METHOD}_${N}_${K}
	    done
done
done
done

#FN rates for SVDquartets+PAUP*
for N in 10 25 50 100 200; do
    for K in 50 100 200; do
	for METHOD in svdquartets_paup; do

            #remove old files
	    cd ${MODELPATH}
	    rm -f temp_${METHOD}_${N}_${K}
	    rm -f FN_${METHOD}_${N}_${K}_R_format.txt

	    for SPECIESNUMBER in {1..20}; do 
		~/phylogenetic_tools/tree_comp/compareTrees.missingBranch ~/scratch/2X-200-500/R${SPECIESNUMBER}/S_relabeled_tree.trees ${MODELPATH}/2X-200-500_svdquartets_paup_trees/${METHOD}_R${SPECIESNUMBER}_${N}_sites_${K}_genes.tree >> ${MODELPATH}/temp_${METHOD}_${N}_${K}
		TEMP=$(awk -vORS= '{ print $3 }' temp_${METHOD}_${N}_${K})
		echo "15-taxon,15,"${METHOD}","${N}","${K}","${SPECIESNUMBER}","${TEMP} >> FN_rates_mammalian_simulated.csv
                rm temp_${METHOD}_${N}_${K}
	    done
done
done
done