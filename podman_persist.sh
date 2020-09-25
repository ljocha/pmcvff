until python3 -u podmand.py 2>&1 | tee -a podmand.log; do
	echo "Podman daemon crashed unexpectedly with exit code $?.  Respawning.." >>podmand.log
	sleep 10
done

