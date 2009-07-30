require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RecipesController do
  before(:each) do
    @recipe = Factory(:recipe, :items => [Factory.build(:item)])
  end

  describe "responding to GET index" do

    it "should expose all recipes as @recipes" do
      get :index
      assigns[:recipes].should == [@recipe]
    end

    describe "with mime type of xml" do
  
      it "should render all recipes as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Recipe.should_receive(:find).with(:all).and_return(recipes = mock("Array of Recipes"))
        recipes.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested recipe as @recipe" do
      get :show, :id => @recipe.id
      assigns[:recipe].should == @recipe
    end
    
    describe "with mime type of xml" do

      it "should render the requested recipe as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Recipe.should_receive(:find).with("37").and_return(@recipe)
        @recipe.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new recipe as @recipe" do
      recipe = Factory.build(:recipe)
      Recipe.should_receive(:new).and_return(recipe)
      get :new
      assigns[:recipe].should equal(recipe)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested recipe as @recipe" do
      get :edit, :id => @recipe.id
      assigns[:recipe].should == @recipe
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_recipe = Factory.build(:recipe)
    end

    describe "with valid params" do

      it "should expose a newly created recipe as @recipe" do
        Recipe.should_receive(:new).with({'these' => 'params'}).and_return(@new_recipe)
        post :create, :recipe => {:these => 'params'}
        assigns(:recipe).should equal(@new_recipe)
      end

      it "should redirect to the created recipe" do
        Recipe.stub!(:new).and_return(@new_recipe)
        post :create, :recipe => {}
        response.should redirect_to(recipe_url(@new_recipe))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_recipe.stub!(:save => false)
      end

      it "should expose a newly created but unsaved recipe as @recipe" do
        Recipe.stub!(:new).with({'these' => 'params'}).and_return(@new_recipe)
        post :create, :recipe => {:these => 'params'}
        assigns(:recipe).should equal(@new_recipe)
      end

      it "should re-render the 'new' template" do
        Recipe.stub!(:new).and_return(@new_recipe)
        post :create, :recipe => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before(:each) do
      Recipe.should_receive(:find).with(@recipe.id.to_s).and_return(@recipe)
    end

    it "should update the requested recipe" do
      @recipe.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @recipe.id, :recipe => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @recipe.stub!(:update_attributes => true)
      end

      it "should expose the requested recipe as @recipe" do
        put :update, :id => @recipe.id
        assigns(:recipe).should equal(@recipe)
      end

      it "should redirect to the recipe" do
        put :update, :id => @recipe.id
        response.should redirect_to(recipe_url(@recipe))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @recipe.stub!(:update_attributes => false)
      end

      it "should expose the recipe as @recipe" do
        put :update, :id => @recipe.id
        assigns(:recipe).should equal(@recipe)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @recipe.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested recipe" do
      Recipe.should_receive(:find).with(@recipe.id.to_s).and_return(@recipe)
      @recipe.should_receive(:destroy)
      delete :destroy, :id => @recipe.id
    end
  
    it "should redirect to the recipes list" do
      delete :destroy, :id => @recipe.id
      response.should redirect_to(recipes_url)
    end

  end

end
