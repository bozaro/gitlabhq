require 'spec_helper'

describe "Admin::Projects" do
  before do
    @project = create(:project)
    login_as :admin
  end

  describe "GET /admin/projects" do
    before do
      visit admin_projects_path
    end

    it "should be ok" do
      current_path.should == admin_projects_path
    end

    it "should have projects list" do
      page.should have_content(@project.name)
    end
  end

  describe "GET /admin/projects/:id" do
    before do
      visit admin_projects_path
      click_link "#{@project.name}"
    end

    it "should have project info" do
      page.should have_content(@project.path)
      page.should have_content(@project.name)
    end
  end

  describe "GET /admin/projects/:id/edit" do
    before do
      visit admin_projects_path
      click_link "edit_project_#{@project.id}"
    end

    it "should have project edit page" do
      page.should have_content("Project name")
      page.should have_content("URL")
    end

    describe "Update project" do
      before do
        fill_in "project_name", with: "Big Bang"
        click_button "Save Project"
        @project.reload
      end

      it "should show page with  new data" do
        page.should have_content("Big Bang")
      end

      it "should change project entry" do
        @project.name.should == "Big Bang"
      end
    end
  end

  describe "GET /admin/projects/new" do
    before do
      visit admin_projects_path
      click_link "New Project"
    end

    it "should be correct path" do
      current_path.should == new_admin_project_path
    end

    it "should have labels for new project" do
      page.should have_content("Project name is")
    end
  end

  describe "POST /admin/projects" do
    before do
      visit new_admin_project_path
      fill_in 'project_name', with: 'NewProject'
      expect { click_button "Create project" }.to change { Project.count }.by(1)
      @project = Project.last
    end

    it "should be correct path" do
      current_path.should == admin_project_path(@project)
    end

    it "should show project" do
      page.should have_content(@project.name)
      page.should have_content(@project.path)
    end
  end

  describe "Add new team member" do
    before do
      @new_user = create(:user)
      visit admin_project_path(@project)
    end

    it "should create new user" do
      select @new_user.name, from: "user_ids"
      expect { click_button "Add" }.to change { UsersProject.count }.by(1)
      page.should have_content @new_user.name
      current_path.should == admin_project_path(@project)
    end
  end
end
