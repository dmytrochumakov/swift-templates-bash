#!/bin/bash

sh clean.sh

echo "Plese enter feature name"
read feature_name

echo "Please provide path where you want to template installed:"
read destination

temp_file="temp.swift"

create_file() {
touch -f $1
}

reset_temp_file() {
> $temp_file
}

replace_template_name_and_write_to_file() {
sed -e "s/$1/$2/g" $temp_file > $3
}

# view_model
view_model_name=$feature_name"VM"
view_model_template_name="__VM__Template__"
view_model_file_name=$view_model_name".swift"

create_file $view_model_file_name

cat << EOF > $temp_file
import Foundation

final class ${view_model_template_name}: ObservableObject {

    @Published private(set) var state: State
    private let navigation: ${feature_name}Navigation

    init(
        navigation: ${feature_name}Navigation
    ) {
        self.navigation = navigation
        self.state = State()
    }

}

// MARK: - Input/State
extension ${view_model_template_name} {

    enum Input: Sendable {
	case onAppear
    }

    struct State: Equatable {

    }

}

// MARK: - Trigger
extension ${view_model_template_name} {

    func trigger(_ input: Input) {
        switch input {
        case .onAppear:
		break
	}
	}

}

#if DEBUG
// MARK: - Stub 
extension ${view_model_template_name} {

	static var stub: ${view_model_template_name} {
		return ${view_model_template_name}(navigation: .stub) 
	}

}
#endif
EOF

replace_template_name_and_write_to_file $view_model_template_name $view_model_name $view_model_file_name

# view
view_name=$feature_name"View"
view_template_name="__View__Template__"
view_file_name=$view_name".swift"

reset_temp_file

create_file $view_file_name

cat << EOF > $temp_file
import SwiftUI
import ApplicationCore
import CommonUI

struct ${view_name}: View {
    
    @StateObject private var viewModel: ${feature_name}VM
    
    init(viewModel: ${feature_name}VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            contentView
        }
        .background(ColorNew.Background.white.color)
        .onAppear {
            viewModel.trigger(.onAppear)
        }
    }
    
}

// MARK: - Views
extension ${view_name} {
    
    var contentView: some View {
        ScrollView {
	}
}

}

#if DEBUG
// MARK: - Stub
extension ${view_name} {
    
    static var stub: ${view_name} {
	    return ${view_name}(viewModel: .stub)
    }
	
}
#endif
EOF

replace_template_name_and_write_to_file $view_template_name $view_name $view_file_name

# navigation
navigation_name=$feature_name"Navigation"
navigation_template_name="__Navigation__Template__"
navigation_file_name=$navigation_name".swift"

reset_temp_file

create_file $navigation_file_name

cat << EOF > $temp_file
import ApplicationCore

struct $navigation_name {

}

#if DEBUG
// MARK: - Stub
extension $navigation_name {
    
    static var stub: $navigation_name {
	return $navigation_name()
    }

}
#endif
EOF

replace_template_name_and_write_to_file $navigation_template_name $navigation_name $navigation_file_name

xcrun swift-format --in-place *.swift

mkdir $feature_name
current_dir=$(pwd)
feature_dir="$current_dir/$feature_name"

cp $view_model_file_name $feature_dir
cp $view_file_name $feature_dir
cp $navigation_file_name $feature_dir

cp -rp $feature_dir $destination

rm -rf $feature_dir

ls
