#!/bin/bash
set -e
cd templates
FILES=$(find -follow)

pre_gen_cleanup() {
    rm -rf ../latest
    for version in ${VERSIONS}; do
        rm -rf ../${version}
    done
}

# postgresql specific
pg_generate_symlinks() {
    echo "Creating symlinks:"
    for version in ${VERSIONS}; do
        cd ../${version}
        echo "    ${version}/README.md -> ${version}/root/usr/share/container-scripts/postgresql/README.md"
        ln -s root/usr/share/container-scripts/postgresql/README.md README.md
        echo "    ${version}/test test"
        ln -s ../test test
    done
    cd ..
    echo "Moving 9.6 version to latest"
    if [ -d "./latest" ]; then
        echo "Failed to copy directory: ./latest already exists"
        exit 1
    fi
    mv 9.6 ./latest
    echo "Creating symlink 9.6->latest"
    ln -s latest 9.6
}

generate_file() {
    if [ -L $1 ]; then
        echo "Skipping symbolic link: $1"
        return
    elif [[ -d $1 && ! -d ../${version}/$1 ]]; then
        mkdir ../${version}/$1
    else
        echo "Generating: ${version}/$1"
        /usr/bin/dg --max-passes 1 --multispec ../specs/multispec.yml \
        --template $1 --distro centos-7-x86_64.yaml \
        --multispec-selector version=${version} --output ../${version}/$1
    fi
    if [ -x $1 ]; then
        chmod +x ../${version}/$1
    fi
}

generate_dockerfiles() {
    mkdir ../$1
    echo "Generating Dockerfile: $1/Dockerfile"
    /usr/bin/dg --max-passes 25 --template ${PWD}/../Dockerfile.template \
        --multispec ../specs/multispec.yml --distro centos-7-x86_64.yaml \
        --multispec-selector version=$1 --output ../$1/Dockerfile
    echo "Generating Dockerfile: $1/Dockerfile.rhel7"
    /usr/bin/dg --max-passes 25 --template ${PWD}/../Dockerfile.template \
        --multispec ../specs/multispec.yml --distro rhel-7-x86_64.yaml \
        --multispec-selector version=$1 --output ../$1/Dockerfile.rhel7

}

pre_gen_cleanup

for version in ${VERSIONS}; do
    generate_dockerfiles $version

    # iterate all directories and files in templates except of "."
    for file in ${FILES[@]:1}; do
        generate_file $file
    done
done

pg_generate_symlinks
