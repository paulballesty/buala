ActiveAdmin.register Company do

  menu :priority => 3

  filter :name

	index do
    selectable_column
    column :name, :sortable => 'name'
    default_actions
	end

  show do
    attributes_table do
      row :name
      unless company.company_logo.blank?
        row :company_logo do |company|
          image_tag company.company_logo_url     
        end
      end
      row :company_type
      row :category
      row :website
      row :location
      row :description
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :company_logo
      f.input :company_type
      f.input :category
      f.input :website
      f.input :location
      f.input :description
    end
    f.actions
  end
  
end
