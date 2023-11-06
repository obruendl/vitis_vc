puts "*** Regenerate all BSPs ***"

#Note: Script was tested with a single platform only
#Note: Script was tested for zynq-7000

#Read all platforms
puts "Read platform"
foreach spr [glob **/*.spr] {
	platform read $spr
}

#Rebuild all platforms/domains
puts "Rebuild platforms and domains"
set platforms [platform list -dict]
foreach plt_name [dict keys $platforms] {
	#Do not make anything for platforms in repository
	set plt_dict [dict get $platforms $plt_name]
	if {[dict get $plt_dict user_defined] == no} {
	   continue
	}
	# Generate user platforms
	puts "> Platform: $plt_name"
	platform generate $plt_name
	platform active $plt_name
	set domains [dict keys [domain list -dict]]
	foreach domain $domains {
		puts " > Domain: $domain"
		domain active $domain
		::scw::regenerate_psinit 
		bsp reload
		bsp regenerate
	}
	repo -add-platforms ./$plt_name
}

#Switch platform for all aps
puts "Configure apps"
set apps [app list -dict]
foreach app_name [dict keys $apps] {
	puts "> App: $app_name"
	set app_dict [dict get $apps $app_name]
	set app_platform [dict get $app_dict platform]
	app switch -name $app_name -platform $app_platform
}
