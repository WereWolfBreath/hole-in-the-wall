class ReviewsController < ApplicationController

    get "/my-reviews" do
        if logged_in?
        @reviews = current_user.reviews # shows all of this specific user's reviews
        erb :'/reviews/show_my_reviews', :layout => :logged_in # Gives links to each review - Gives link to the Home Page
        else
            redirect to '/hole-in-the-wall'
        end
    end

    get "/my-reviews/:id" do
        @user_review = Review.find_by_id(params[:id]) # finds the right review from post "/my-reviews" @review
        if logged_in? && current_user.id  == @user_review.user_id # if the user is logged in and their user_id is equal to the @user_review params id
        erb :'/reviews/show_individual_review', :layout => :logged_in # Shows the correct review.
        elsif !logged_in?
            redirect to '/hole-in-the-wall'
        else
            erb :'/reviews/error_no_access'
        end
    end

    post "/my-reviews/:id" do
        @review = Review.new(params[:review])
        if @review.valid?
            @review.store_id = params[:id]
            @review.user_id = session[:user_id]
            @review.save
        redirect to "/my-reviews/#{@review.id}" # it is redirected to that specific review from @review
        else
            redirect to "/my-reviews"
        end
    end



    get "/my-reviews/:id/edit" do
        @user_review = Review.find_by_id(params[:id]) # keeps the same id from the right review

        if logged_in? && current_user.id  == @user_review.user_id # if the user is logged in and their user_id is equal to the @user_review params id
        erb :'/reviews/edit', :layout => :logged_in # Allows the user to edit that review.
        elsif logged_in?
            redirect to '/hole-in-the-wall'
        else
            erb :'/reviews/error_no_access' # they get the error message if it is not their review
        end
    end

    patch "/my-reviews/:id" do # patch request to the specific id
        @editing = Review.find_by_id(params[:id]) # finds the right id to patch
        if logged_in? && current_user.id  == @editing.user_id
            if valid_params?
                @editing.update(params[:review])
                redirect to "/my-reviews/#{@editing.id}" # redirects to the specific id page
            else
                redirect to '/my-reviews/form'
            end
        else
            erb :'/reviews/error_no_access'
        end
    end

    delete "/my-reviews/:id" do
        @deletion = Review.find_by_id(params[:id]) # will find the review by the params id

        if logged_in? && current_user.id == @deletion.user_id # if the current user is equal to the review user id
        @deletion.delete # then we will delete the post. 
        redirect '/my-reviews' # Redirected to their reviews.
        else
            erb :'/reviews/error_no_access' # if they do not, then they shall get the error page.
        end
    end

end