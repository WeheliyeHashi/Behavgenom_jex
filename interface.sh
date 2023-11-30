#!/bin/bash

echo "Welcome to Behave Genoms Tierpsy Tracker"

PS3='Please choose an option: '
options=("Batch Processing and Feature Summary" "Feature Summary only" "View Job Status" "Cancel Job" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Batch Processing and Feature Summary")
            echo "you chose choice $opt for batch processing and feature summary"
	    sh ./Behavgenom_jex/workspace/batch_processing.sh
            echo 'Please choose an option: '
            printf '%s\n' "1) Batch Processing and Feature Summary" "2) Feature Summary only" "3) View Job Status" "4) Cancel  Job" "5) Quit"
            ;;
        "Feature Summary only")
            echo "you chose choice $opt to only do feature summary"
            sh ./Behavgenom_jex/workspace/run_features_summaries_only.sh
            echo 'Please choose an option: '
            printf '%s\n' "1) Batch Processing and Feature Summary" "2) Feature Summary only" "3) View Job Status" "4) Cancel Job" "5) Quit"
            ;;
        "View Job Status")
            echo "you chose $opt to exit"
            squeue --user weheliye
            echo 'Please choose an option: '
            printf '%s\n' "1) Batch Processing and Feature Summary" "2) Feature Summary only" "3) View Job Status" "4) Cancel Job" "5) Quit"
            ;;
         "Cancel Job")
            read -p "Please type in the job number you want to cancel: "  job_id
            scancel $job_id 
            echo 'Please choose an option: '
            printf '%s\n' "1) Batch Processing and Feature Summary" "2) Feature Summary only" "3) View Job Status" "4) Cancel Job" "5) Quit"
            ;;
	"Quit")
            echo "you chose to $opt"

            break
            exit 0
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

