addNewAddOn() {
    local base_addons_dir="$1"
    local custom_addons_dir="$2"
    local addon_repo_url="$3"
    local current_dir="$4"

    echo "******"

    # Switch to the base AddOns directory
    cd $base_addons_dir

    main_branch="master"
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    swapped_branches=false

    # Switch to master branch
    if [ $current_branch != $main_branch ]; then
        echo -e "\ncalling: git checkout $main_branch"
        (git checkout $main_branch)
        swapped_branches=true
    fi

    # Add the submodule
    cd "./submodules"
    echo -e "\ncalling: git submodule add $addon_repo_url"
    (git submodule add $addon_repo_url)

    addon_names=()

    # Create new symbolic links to base addon directory (containg the .toc file)
    for file in $(find . -name '*.toc'); do
        parent_dir=$(dirname $file)
        cd ".."
        ln -s "./submodules/$parent_dir"
        cd "./submodules"
        addon_names+=($(basename $parent_dir))
    done

    # Commit and push changes
    commit_message="Added new addon(s):"
    for name in ${addon_names[@]}; do
        commit_message+=" $name"
    done

    echo -e "\ncalling: git add . && git commit -m $commit_message && git push"
    (git add . && git commit -m $commit_message && git push)

    # Switch to original branch
    if $swapped_branches; then
        echo -e "\ncalling: git checkout $current_branch"
        (git checkout $current_branch)
    fi

    # Switch to the custom AddOns directory
    cd $custom_addons_dir

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    swapped_branches=false

    # Switch to master branch
    if [ $current_branch != $main_branch ]; then
        echo -e "\ncalling: git checkout $main_branch"
        (git checkout $main_branch)
        swapped_branches=true
    fi

    # Pull changes from upstream
    echo -e "\ncalling: git pull upstream master"
    (git pull upstream master)

    # Switch to original branch
    if $swapped_branches; then
        echo -e "\ncalling: git checkout $current_branch"
        (git checkout $current_branch)
    fi


    # Switch to original directory
    cd $current_dir
    echo ""
}
