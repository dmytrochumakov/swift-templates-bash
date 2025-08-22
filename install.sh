#!/bin/bash

sh clean.sh
# TODO
# Path to directory where I want to install template
# Feature Name - done
# Create Files - done only for MVP architecture
# Fill Files with template code
# Move files to from source to destination
#
#echo "Please select template:"
#echo "MVP: 1, MVVM+SwiftUI: 2, TCA: 3"
#read template

#echo "Plese enter feature name"
#read feature_name
feature_name="News"
# mvp
# presenter
presenter_name=$feature_name"Presenter"
presenter_template_name="__Presenter__Template__"
presenter_file_name=$presenter_name".swift"

temp_file="temp.swift"

touch -f $presenter_file_name

cat << EOF > $temp_file
protocol $presenter_template_name {

}

final class ${presenter_template_name}Impl {
	
	init() { 
	}

}

// MARK: - $presenter_template_name
extension ${presenter_template_name}Impl: $presenter_template_name {

}
EOF

sed -e "s/$presenter_template_name/$presenter_name/g" $temp_file > $presenter_file_name

# presenter
view_controller_name=$feature_name"ViewController"
view_controller_template_name="__View__Controller__Template__"
view_controller_file_name=$view_controller_name".swift"

> $temp_file

touch -f $view_controller_file_name

cat << EOF > $temp_file
protocol ${view_controller_name}Input {

}

final class ${view_controller_name}Impl {
	
	init() { 
		super.init(nibName: nil, bundle: Bundle.module)
	}

}

// MARK: - ${view_controller_name}Input
extension ${view_controller_name}Impl: ${view_controller_name}Input {

}
EOF

sed -e "s/$view_controller_template_name/$view_controller_name/g" $temp_file > $view_controller_file_name

xcrun swift-format --in-place *.swift

ls
nvim $view_controller_file_name
