until python3 -u podmand.py >>podman_d.log; do
	echo "Podman daemon crashed unexpectedly with exit code $?.  Respawning.." >>podman_d.log
	sleep 10
done

echo "Podman daemon finished gracefuly" >>podman_d.log
