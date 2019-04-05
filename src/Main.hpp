#ifndef MAIN_HPP
#define MAIN_HPP

#ifdef __APPLE__
	#include "MacOS/MacHelper.hpp"
	MacHelper __macHelper;
#endif // __APPLE__

#ifdef __linux__
	#include "Linux/LinuxHelper.hpp"
	LinuxHelper __linuxHelper;
#endif // __linux__

//

#endif // MAIN_HPP
