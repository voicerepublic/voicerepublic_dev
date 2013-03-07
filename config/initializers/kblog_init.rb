# some initialization for kblog


Kblog.blog_title = "KluuU - Blog"
Kblog.user_class = 'User'     # class of blog-author

# select EITHER section basic or role-based authentication
#
#######################################################
# role-based rights to create/alter blog-articles		#
# user_class must respond_to :roles - and each role	#
# string representation role.to_s == Kblog.auth_role	#
#######################################################

Kblog.auth_type = 'role'   
Kblog.auth_role = 'admin'   # role needed to alter blogs

#########################################################
# http-basic-auth                                       #
#########################################################
#Kblog.auth_type == 'basic'
#Kblog.authname = 'blogger'
#Kblog.authpassword = 'changeme'

ActiveSupport.on_load :action_controller do
	helper Kblog::ArticlesHelper
end


require 'RedCloth'
require 'will_paginate'
