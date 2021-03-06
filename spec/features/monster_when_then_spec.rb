require 'rails_helper'

feature 'Playing the game', js: true do
  scenario "Sophie Wilson would like to play the game
            and in order to do so she registers" do

    When 'Sophie visits the site to play the game' do
      visit('/')
      focus_on(:game_actions).for_game('wargames').play
    end

    Then 'she must register to continue' do
      wait_for do
        focus_on(:page_content).container_for('register').heading
      end.to eq('Register')
    end

    When 'she signs in with her handle "BBCmicro"' do
      focus_on(:form).form_for('register').submit!(
        handle: 'BBCmicro'
      )
    end

    Then 'her profile is successfully created' do
      wait_for do
        focus_on(:messages).info
      end.to eq('profile successfully created')
    end

    And 'and she is signed in as "BBCmicro"' do
      wait_for { focus_on(:nav).details.summary.text }.to eq('BBCmicro')
    end

    And "she is encouraged to complete her profile
        and also has the option to play the game" do
      wait_for do
        focus_on(:page_content).container_for('profile').text
      end.to include('Your profile is almost complete')
      wait_for do
        focus_on(:page_content).container_for('profile').actions
      end.to eq(['Play the game'])
    end

    When 'she hastily chooses to "Play the game"' do
      focus_on(:page_content)
        .container_for('profile')
        .action_item('Play the game')
    end

    Then 'the game commences' do
      wait_for do
        focus_on(:page_content).container_for('game').heading
      end.to eq('coming soon')
    end

    And 'she is informed that she should complete her profile' do
      wait_for do
        focus_on(:page_content).container_for('game').actions
      end.to eq(['Complete my profile'])
    end

    When 'she selects "complete my profile"' do
      focus_on(:page_content)
        .container_for('game')
        .action_item('Complete my profile')
    end

    And 'submits her name "Sophie Wilson"' do
      focus_on(:form).form_for('profile').submit!(
        name: 'Sophie Wilson'
      )
    end

    And 'submits her email "sophie.wilson@acorn.co.uk"' do
      focus_on(:form).form_for('profile').submit!(
        email: 'sophie.wilson@acorn.co.uk'
      )
    end

    And 'submits her avatar url "sample_avatars/bbc_micro_80_80.png' do
      focus_on(:form).form_for('profile').submit!(
        avatarUrl: '/sample_avatars/bbc_micro_80_80.png'
      )
    end

    Then 'her profile is complete' do
      wait_for { focus_on(:profile).details }.to eq(
        handle: 'BBCmicro',
        name: 'Sophie Wilson',
        email: 'sophie.wilson@acorn.co.uk',
        avatarUrl: '/sample_avatars/bbc_micro_80_80.png'
      )
    end

    When 'Sophie tries to update her handle and email to that of Jean Sammet' do
      visit('/profile')
      focus_on(:page_content).container_for('profile').action_item('Edit')
      focus_on(:form).form_for('profile').fill_in_row_for('handle', 'FORMAC')
      focus_on(:form).form_for('profile').fill_in_row_for('name', 'Jean Sammet')
      focus_on(:form).form_for('profile').fill_in_row_for('email', 'jean.sammet@ibm.com')
      focus_on(:form).form_for('profile').submit
    end

    Then 'they are updated successfully' do
      wait_for { focus_on(:profile).details }.to eq(
        handle: 'FORMAC',
        name: 'Jean Sammet',
        email: 'jean.sammet@ibm.com',
        avatarUrl: '/sample_avatars/bbc_micro_80_80.png'
      )
    end

    When 'the page is refreshed' do
      page.refresh
    end

    Then 'all the fields are persisted' do
      wait_for { focus_on(:profile).details }.to eq(
        handle: 'FORMAC',
        name: 'Jean Sammet',
        email: 'jean.sammet@ibm.com',
        avatarUrl: '/sample_avatars/bbc_micro_80_80.png'
      )
    end

    When 'Jean visits their profile page in the original loading state' do
      with_api_route_paused(method: 'get', url: '/api/v1/profiles') do
        visit('/profile')
        wait_for { focus_on(:util).test_elements('spinner') }.to eq ['Loading...']
      end
    end

    Then 'the loading element is no longer visible' do
      wait_for { focus_on(:util).test_elements('profile') }.to_not include('Loading...')
    end

    Given 'the profiles API throws errors' do
      force_api_error(method: 'get', url: '/api/v1/profiles', error: 'failed to fetch profile')
    end

    When 'user visits their profile page' do
      visit('/profile')
    end

    Then 'they get an error' do
      wait_for { focus_on(:messages).error }.to eq '500 - Internal Server Error'
    end

    And 'the API stops throwing errors' do
      clear_api_error
      page.refresh
    end

    When 'user visits their profile page' do
      visit('/profile')
    end

    When 'she chooses to "Play the game"' do
      focus_on(:page_content)
        .container_for('profile')
        .action_item('Play the game')
    end

    Then 'the game commences' do
      wait_for do
        focus_on(:page_content).container_for('game').heading
      end.to eq('coming soon')
    end

    And 'her profile is complete with no further actions required' do
      wait_for do
        focus_on(:page_content).container_for('game').text
      end.to include('Your profile is complete!')
      wait_for do
        focus_on(:page_content).container_for('game').actions
      end.to eq([])
    end

    When '"BBCmicro" signs out' do
      focus_on(:nav).details.click_detail('Sign out')
    end

    Then 'she is no longer signed in' do
      wait_for { focus_on(:nav).nav_links }.to eq ['Sign in', 'Register']
    end

    When 'Barbara Liskov plays the game' do
      visit('/')
      focus_on(:game_actions).for_game('wargames').play
    end

    Then 'she must register' do
      wait_for do
        focus_on(:page_content).container_for('register').heading
      end.to eq('Register')
    end

    When 'Barbara attempts to register as "FORMAC"' do
      focus_on(:form).form_for('register').fill_in_row_for('handle', 'FORMAC')
      focus_on(:form).form_for('register').submit
    end

    Then 'she is informed the handle has already been taken' do
      wait_for { focus_on(:messages).error }.to eq('handle: has already been taken')
    end

    When 'Barbara chooses "CLU"' do
      focus_on(:form).form_for('register').fill_in_row_for('handle', 'CLU')
      focus_on(:form).form_for('register').submit
    end

    Then 'her profile is successfully created and she is signed in' do
      wait_for { focus_on(:messages).info }.to eq('profile successfully created')
      wait_for { focus_on(:nav).details.summary.text }.to eq('CLU')
    end

    When 'she chooses to "Play the game"' do
      focus_on(:page_content)
        .container_for('profile')
        .action_item('Play the game')
    end

    Then 'the game commences' do
      wait_for do
        focus_on(:page_content).container_for('game').heading
      end.to eq('coming soon')
    end
  end
end
