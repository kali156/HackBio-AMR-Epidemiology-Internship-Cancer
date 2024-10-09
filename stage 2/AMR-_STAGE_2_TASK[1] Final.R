#===================================library
library(tidyverse)
library(ggsci) 
library(ggplot2)
library(dplyr)

#====================================loading data
data <- read.delim("https://raw.githubusercontent.com/HackBio-Internship/public_datasets/main/R/WHO_AMR_PRODUCTS_DATA.tsv", sep = "\t", header = TRUE)
#====================================cleaning data 
AMR_Products <- data %>%
  filter(Active.against.priority.pathogens. !='N/A')%>%
  group_by(Product.type, Active.against.priority.pathogens.) 

view(AMR_Products)
dim(AMR_Products)
table(AMR_Products$Product.name)


# Distribution of Product Type
Product_type_summary<-AMR_Products%>%
  group_by(Product.type)%>%
  summarise(count=n())
Product_type_summary


ggplot(Product_type_summary, aes(x = Product.type, y = count, fill =Product.type)) +
  geom_bar(stat = 'identity',width = 0.3,position = 'dodge') +
  scale_fill_manual(values = c("#4F81BD", "#C0504D"))  +
  theme_minimal()+xlab('')+
  theme(text = element_text(size = 9),
        plot.title = element_text(hjust =0.5,face = 'bold' ),legend.position = "bottom")


#Test the product activity
product_activity<-AMR_Products%>%
  group_by(Product.type, Active.against.priority.pathogens.)%>%
  summarise(Count=n())
product_activity


# Create the stacked bar chart that shows distribution of Product Type with activity status
ggplot(product_activity, aes(x = Product.type, y = Count, fill = Active.against.priority.pathogens.)) +
  geom_bar(stat = "identity", width = 0.8) +  
  scale_fill_manual(values = c("Yes" = "#FF5733", "No" = "grey", "Possibly" = "#3357FF")) +
  labs(
    x = "Product Type",
    y = "Count",
    fill = "Activity Status"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")


# Summarize the data
Route_Activity_relation <- AMR_Products %>%
  group_by(Route.of.administration, Active.against.priority.pathogens.) %>%
  summarise(Count = n(), .groups = 'drop')
Route_Activity_relation

# relation between Route Route.of administration and activity status
ggplot_plot <- ggplot(Route_Activity_relation, aes(x = Route.of.administration, y = Count, color = Active.against.priority.pathogens.)) +
  geom_point(size = 3) +
  scale_color_manual(values = c("Yes" = "#FF5733", "No" = "grey", "Possibly" = "#3357FF")) +
  labs(title = "Relationship Between Route of Administration and Drug Effectiveness",
       x = "Route of Administration",
       y = "Number of Products",
       color = "Effectiveness Against Priority Pathogens") +
  theme_minimal() +
  theme(legend.position = "bottom", legend.title.position = "bottom")

ggplot_plot


#================================Antibiotics data
Antibiotics <- data %>% filter(Product.type == "Antibiotics")

#what is the R.D phase of antibiotic products
ggplot(Antibiotics,mapping  = aes(R.D.phase,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(50))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.ticks.y = element_blank())

#A:The vast majority of new antibiotic products present in phase 1


#what is the route of adminstrtion of the products
ggplot(Antibiotics,mapping = aes(Route.of.administration,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(46))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10)
  )

#loading Antibiotics data that had been shown result after testing 
Antibiotics <- AMR_Products %>% filter(Product.type == "Antibiotics")

# Activity status of the antibotics aganist pathogens
ggplot(Antibiotics,mapping = aes(Active.against.priority.pathogens.,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(50))



################################################################################
# non traditional data categories
Non.traditional = AMR_Products%>%filter(Product.type=="Non-traditional")
Non.traditional
colnames(Non.traditional)

ggplot(Non.traditional, aes(x = "", y = Non.traditionals.categories, fill = factor(Non.traditionals.categories))) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  scale_fill_discrete(name = "Non.traditionals.categories") +
  labs(title = "Pie Chart of Non.traditionals.categories") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "bottom",legend.title.position = "top")



##Which category has effect and on which pathogens

# Create a simple dot plot 
ggplot(Non.traditional, aes(x = Non.traditionals.categories, y = Pathogen.name)) +
  geom_point(aes(color = Pathogen.name), size = 3, position = position_jitter(width = 0.2, height = 0.2)) +
  labs(title = "Effect of Products on Pathogens",
       x = "Non.traditionals.categories",
       y = "Pathogen Name",
       color = "Pathogen Name") +
  theme(legend.position = "bottom")





############################################################################
#========================== create Bacteriophages_and_phage_derived_enzymes_data
Bacteriophages_and_phage_derived_enzymes_data <- data %>%
  filter(Non.traditionals.categories == "Bacteriophages and phage-derived enzymes")

Bacteriophages_and_phage_derived_enzymes_data

#what is the route of adminstrtion
ggplot(Bacteriophages_and_phage_derived_enzymes_data,mapping = aes(Route.of.administration,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))

#what is R.D phase of this proucts
ggplot(Bacteriophages_and_phage_derived_enzymes_data,mapping = aes(R.D.phase,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))

#products of Bacteriophages_and_phage_derived_enzymes aganist pathogens.
#--------------------------------------------------------------
#loading_data
Bacteriophages_and_phage_derived_enzymes_data <- AMR_Products %>% filter(Non.traditionals.categories == "Bacteriophages and phage-derived enzymes")
#visualize data
ggplot(Bacteriophages_and_phage_derived_enzymes_data,mapping = aes(Active.against.priority.pathogens.,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10)
  )





#######################################################################################################
#========================== create Immunomodulating_agents_data
Immunomodulating_agents_data <- data %>% filter(Non.traditionals.categories == "Immunomodulating agents")

# what products used in Immunomodulating_agents_activity
ggplot(Immunomodulating_agents_data,mapping = aes(Antibacterial.class,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))


#what is R.D phase of this proucts
ggplot(Immunomodulating_agents_data,mapping = aes(R.D.phase,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))

#what is the route of adminstrtion
ggplot(Immunomodulating_agents_data,mapping = aes(Route.of.administration,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))

#Immunomodulating_agents_activity_data that have been Tested in activity against piority pathogen data
Immunomodulating_agents_activity_data <- AMR_Products %>% filter(Non.traditionals.categories == "Immunomodulating agents")

#Application on different pathogens
Immunomodulating_agents <- Non.traditional %>%
  filter(Product.name %in% c("Rhu-pGSN", "AB103"))
Immunomodulating_agents

# Create a dot plot
ggplot(Immunomodulating_agents, aes(x = Product.name, y = Pathogen.name)) +
  geom_point(aes(color = Pathogen.name), size = 3, position = position_jitter(width = 0.2, height = 0.2)) +
  labs(title = "Effect of Rhu-pGSN and AB103 on Pathogens",
       x = "Product Name",
       y = "Pathogen Name",
       color = "Pathogen Name") +
  theme(
    text = element_text(size = 16),  # Set base font size for all text
    plot.title = element_text(size = 20, face = "bold"),  
    axis.title.x = element_text(size = 18),               
    axis.title.y = element_text(size = 18),               
    axis.text.x = element_text(size = 14, angle = 25, hjust = 1),  
    axis.text.y = element_text(size = 14),                 
    legend.text = element_text(size = 14),                 
    legend.title = element_text(size = 16),                
    legend.position = "bottom"                             
  )





#############################################################################
Microbiome_modulating_agents <- data %>% filter(Non.traditionals.categories == "Microbiome-modulating agents")
# what is the anti bacterial class that have been used in Microbiome_modulating_agents
ggplot(Microbiome_modulating_agents,mapping = aes(Antibacterial.class,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))


#what is R.D phase of this products
ggplot(Microbiome_modulating_agents,mapping = aes(R.D.phase,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))

#what pathogens had been tried aganist products
ggplot(Microbiome_modulating_agents,mapping = aes(Pathogen.name,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))


#what is the route of administration
ggplot(Microbiome_modulating_agents,mapping = aes(Route.of.administration,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))


# products of microbe_modulating_agents aganist pathogens.
#---------------------------------------------------------------
# LOADING Data of microbe modulating agents filtrate from "N/A
microbe_modulating_agents_data <- AMR_Products %>% filter(Non.traditionals.categories == "Microbiome-modulating agents")
#Visualize data
ggplot(microbe_modulating_agents_data,mapping = aes(Active.against.priority.pathogens.,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10)
  )


############################################################################
#========================== create Miscellaneous data
Miscellaneous_data <- data %>% filter(Non.traditionals.categories == "Miscellaneous")
# what is the anti bacterial class that have been used in Miscellaneous
ggplot(Miscellaneous_data,mapping = aes(Antibacterial.class,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10))+coord_flip()

#what is R.D phase of this products
ggplot(Miscellaneous_data,mapping = aes(R.D.phase,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10)
  )
#what is the route of administration
ggplot(Miscellaneous_data,mapping = aes(Route.of.administration,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10)
  )
#products of Miscellaneous against pathogens.
#--------------------------------------------------------------
#loading_data
Miscellaneous_activity_data <- AMR_Products %>% filter(Non.traditionals.categories == "Miscellaneous")
#visualize data
ggplot(Miscellaneous_activity_data,mapping = aes(Active.against.priority.pathogens.,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10))




#--------------------------------------------------------------
#========================== create antibodies data
antibodies_data <- data %>% filter(Non.traditionals.categories == "Antibodies")
# what is the anti bacterial class that have been used in Antibodies
ggplot(antibodies_data,mapping = aes(Antibacterial.class,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10))+coord_flip()

#what is R.D phase of this products
ggplot(antibodies_data,mapping = aes(R.D.phase,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))

#what pathogens had been tried against products
ggplot(antibodies_data,mapping = aes(Pathogen.name,fill=Product.name))+geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))+
  theme(axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        plot.title = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 10,angle = 45, hjust = 1),
        axis.text.y = element_text(size = 10)
  )
#what is the route of administration
ggplot(antibodies_data,mapping = aes(Route.of.administration,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))


#products of antibodies against pathogens.
#--------------------------------------------------------------
#loading_data
antibodies_activity_data <- AMR_Products %>% filter(Non.traditionals.categories == "Antibodies")
#visualize data
ggplot(antibodies_activity_data,mapping = aes(Active.against.priority.pathogens.,fill=Product.name))+
  geom_bar()+theme_light()+scale_fill_manual(values = pal_igv()(20))



