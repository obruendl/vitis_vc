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
set platforms [dict keys [platform list -dict]]
foreach platform $platforms {
	puts "> Platform: $platform"
	platform generate $platform
	platform active $platform
	set domains [dict keys [domain list -dict]]
	foreach domain $domains {
		puts " > Domain: $domain"
		domain active $domain
		::scw::regenerate_psinit 
		bsp reload
		bsp regenerate
	}
	repo -add-platforms ./$platform
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
