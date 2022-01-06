#!/bin/bash

# get deployments
# kubectl get deployment -n odoo -o=name | grep odoo1 | sed "s/^.\{16\}//" |\



my_func() {
    deploy="$1"
    echo "#############"
    echo "$deploy "
    echo "#############"

    # Restart deployment
    echo "restarting"
    sleep 5

    # Get new pod
    echo "getting new pod"
    pod="segemind-12355"

       while read pod; \
       do
           echo "* $pod"
           echo "- Copyng executing script..."
           # kubectl cp ./update_module.py odoo/$pod:/opt/odoo_dir/odoo
           echo "- Executing script..."
           # kubectl exec -n odoo -t $pod -- bash -c "cd /opt/odoo_dir/odoo && python update_module.py localhost:8069"
       done
}

update_modules() {

    deploy="$1"
    echo "#############"
    echo "$deploy "
    echo "#############"

   # Restart deployment
   # kubectl rollout restart deployment $deploy -n odoo
   sleep 30

   # Get new pod
   kubectl get pods -n odoo -o=name --field-selector=status.phase=Running | grep $deploy | sed "s/^.\{4\}//" |\
       while read pod; \
       do
           echo "* $pod"
           echo "- Copyng executing script..."
           # kubectl cp ./update_module.py odoo/$pod:/opt/odoo_dir/odoo
           echo "- Executing script..."
           # kubectl exec -n odoo -t $pod -- bash -c "cd /opt/odoo_dir/odoo && python update_module.py localhost:8069"
       done

}

export -f my_func


kubectl get deployment -n odoo -o=name | grep odoo1 | sed "s/^.\{16\}//" | parallel -j 2 "update_modules {}"

cat deploys.txt | grep test | parallel -j 2 "my_func {}"

