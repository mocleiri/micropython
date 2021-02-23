# all user modules will hang off this
add_library(usermod INTERFACE)

# recursively gather sources - doesn't support generator expressions
function(usermod_gather_sources VARNAME INCLUDED_VARNAME LIB)
    if (NOT ${LIB} IN_LIST ${INCLUDED_VARNAME})
        list(APPEND ${INCLUDED_VARNAME} ${LIB})
        set(${INCLUDED_VARNAME} ${${INCLUDED_VARNAME}} PARENT_SCOPE)
    endif()
    get_target_property(new_sources ${LIB} INTERFACE_SOURCES)
    if (new_sources)
        list(APPEND ${VARNAME} ${new_sources})
    endif()
    get_target_property(new_sources ${LIB} INTERFACE_LIBRARIES)
    get_target_property(trans_depend ${LIB} INTERFACE_LINK_LIBRARIES)
    if (trans_depend)
        foreach(SUB_LIB ${trans_depend})
            usermod_gather_sources(${VARNAME} ${INCLUDED_VARNAME} ${SUB_LIB})
        endforeach()
    endif()
    set(${VARNAME} ${${VARNAME}} PARENT_SCOPE)
endfunction()

if (USER_C_MODULES)
    foreach(USER_C_MODULE_PATH ${USER_C_MODULES})
        include(${USER_C_MODULE_PATH}/usermod.cmake)
    endforeach()
endif()

usermod_gather_sources(SOURCE_USERMOD _touched usermod)