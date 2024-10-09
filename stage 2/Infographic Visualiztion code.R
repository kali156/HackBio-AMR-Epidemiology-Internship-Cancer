#used library
library(dplyr)
library(ggplot2)
library(plotly)
library(ggsci)

# to Download data
AMR_Products<- read.delim("https://raw.githubusercontent.com/HackBio-Internship/public_datasets/main/R/WHO_AMR_PRODUCTS_DATA.tsv", sep = "\t", header = TRUE)
#preprocessing
AMR_Products[is.na(AMR_Products)]<-'unknown'

write.table(AMR_Products,"AMR_Product.tsv")
#Identify Key Trends:


#1- distribution of Product Type
Product_type_summary<-AMR_Products%>%
  filter(!duplicated(AMR_Products$Product.name))%>%
  group_by(Product.type)%>%
  summarise(count=n())

ggplot(Product_type_summary, aes(x = Product.type, y = count, fill =Product.type)) +
  geom_bar(stat = 'identity',width = 0.3,position = 'dodge') +
  scale_fill_manual(values = c("#4F81BD", "#C0504D"))  +
  theme_minimal()+xlab('')+
  theme(text = element_text(size = 9),
        plot.title = element_text(hjust =0.5,face = 'bold' ))

#

#-----------------
#Create the  bar chart..
#..that shows distribution of Product Type with activity status
product_activity <- AMR_Products %>%
  filter(Active.against.priority.pathogens. !='N/A')%>%
  group_by(Product.type, Active.against.priority.pathogens.) %>%
  summarise(Count = n(), .groups = 'drop')

# Create faceted bar plot
ggplot(product_activity, aes(x = Product.type, y = Count, fill = Active.against.priority.pathogens.)) +
  geom_bar(stat = "identity",width = 0.4) +
  facet_wrap(~ Active.against.priority.pathogens.) +
  scale_fill_manual(values = c("Yes" = "#BC0CFF", "No" = "#008080","Possibly"="#8B0000")) +
  labs(
    x = "Product Type",
    y = "Count",
    fill = "Activity Status") +
  xlab('')
theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(size = 4),
        axis.title.x  = element_text(size = 2),
        axis.text = element_text(size = 4))
  #The relation between Rout of addministraition and drug activity
  # Summarize the data
  Route_Activity_relation <- AMR_Products %>%
    filter(Active.against.priority.pathogens. !='N/A')%>%
    filter(Route.of.administration !='N/A')%>%
    group_by(Route.of.administration, Active.against.priority.pathogens.) %>%
    summarise(Count = n(), .groups = 'drop')
  
  # Create the dot plot with ggplot
  ggplot_plot <- ggplot(Route_Activity_relation, aes(x = Route.of.administration, y = Count, fill = Active.against.priority.pathogens.)) +
    geom_point(size = 3) +
    scale_fill_manual(values = c("Yes" = "green", "No" = "red", "Possibly" = "orange")) +
    labs(title = "Relationship Between Route of Administration and Drug Effectiveness",
         x = "Route of Administration",
         y = "Number of Products",
         color = "Effectiveness Against Priority Pathogens") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(size = 8),
          axis.title = element_text(size = 8),
          axis.text = element_text(size = 8))
  
  # 
  interactive_plot <- ggplotly(ggplot_plot)
  # Display the interactive plot
  interactive_plot
  #uploud the plot online
  htmlwidgets::saveWidget(interactive_plot,'interactive_polt.html')
  Sys.setenv("plotly_username"="Abdullah988")
  Sys.setenv("plotly_api_key"="r4cNVAaAC8iReKbMxLDS")
  api_create(interactive_plot, filename = "plotly")
#________________________________________________________________________
  # Summarize the data to count occurrences of each combination
data <- AMR_Products %>%
    group_by(Product.name, Antibacterial.class, R.D.phase,Pathogen.name,Active.against.priority.pathogens.) %>%
  filter(Active.against.priority.pathogens.!='N/A')%>%
  filter(Active.against.priority.pathogens.!='Possibly')%>%
  
    summarise(Count = n(), .groups = 'drop')
  
 

# Create the bubble chart
bubble_plot <- plot_ly(
  data = data,
  x = ~R.D.phase,
  y = ~Antibacterial.class,
  size = I(10),  # Constant size for all bubbles
  color = ~Active.against.priority.pathogens.,  # Color by activity against priority pathogens
    # Color by activity against priority pathogens
  colors = c("Yes" = "blue", "No" = "red"),
   text = ~paste("Product Name:", Product.name, 
                "<br>Pathogen Name:", Pathogen.name, 
                "<br>Active Against Priority Pathogens:", Active.against.priority.pathogens.),
  hoverinfo = 'text',
  type = 'scatter',
  mode = 'markers'
) %>%
  layout(
    xaxis = list(title = "R&D Phase"),
    yaxis = list(title = "Antibacterial Class"),
    title = "Bubble Plot of Antibacterial Products",
    showlegend = TRUE
  )

# Display the interactive bubble plot
bubble_plot
#upload the plot online
Sys.setenv("plotly_username"="Abdullah988")
Sys.setenv("plotly_api_key"="r4cNVAaAC8iReKbMxLDS")
api_create(bubble_plot, filename = "bubbplot")
#_____________________________________________________________________
#non traditional data categories
Non.traditional=AMR_Products%>%filter(Product.type=="Non-traditional")
Non.traditional
colnames(Non.traditional)

ggplot(Non.traditional, aes(x = "", y = Non.traditionals.categories, 
                            fill = factor(Non.traditionals.categories))) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  scale_fill_discrete(name = "Non.traditionals.categories") +
  labs(title = "Pie Chart of Non.traditionals.categories") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "bottom",legend.title.position = "top")
#Which category has effect on which pathigens

# Create a simple dot plot 
ggplot(Non.traditional, aes(x = Non.traditionals.categories, y = Pathogen.name)) +
  geom_point(aes(color = Pathogen.name), size = 3, position = position_jitter(width = 0.2, height = 0.2)) +
  labs(title = "Effect of Products on Pathogens",
       x = "Non.traditionals.categories",
       y = "Pathogen Name",
       color = "Pathogen Name") +
  theme(legend.position = "bottom")
